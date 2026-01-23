"""Tests for comprehensive tokenizer configuration system."""

import json
import os
import tempfile
from pathlib import Path
from unittest.mock import patch

import pytest

from kano_backlog_core.tokenizer_config import (
    TokenizerConfig,
    TokenizerConfigLoader,
    TokenizerConfigMigrator,
    load_tokenizer_config,
    create_example_config,
    DEFAULT_CONFIG,
    ADAPTER_DEFAULTS,
    ENV_PREFIX,
)
from kano_backlog_core.errors import ConfigError


class TestTokenizerConfig:
    """Test TokenizerConfig class."""
    
    def test_default_config_creation(self):
        """Test creating config with default values."""
        config = TokenizerConfig()
        
        assert config.adapter == "auto"
        assert config.model == "text-embedding-3-small"
        assert config.max_tokens is None
        assert config.fallback_chain == ["tiktoken", "huggingface", "heuristic"]
        assert config.options == {}
        assert config.heuristic["chars_per_token"] == 4.0
        assert config.tiktoken["encoding"] is None
        assert config.huggingface["use_fast"] is True
        assert config.huggingface["trust_remote_code"] is False
    
    def test_custom_config_creation(self):
        """Test creating config with custom values."""
        config = TokenizerConfig(
            adapter="heuristic",
            model="gpt-4",
            max_tokens=8192,
            fallback_chain=["heuristic", "tiktoken"],
            heuristic={"chars_per_token": 3.5}
        )
        
        assert config.adapter == "heuristic"
        assert config.model == "gpt-4"
        assert config.max_tokens == 8192
        assert config.fallback_chain == ["heuristic", "tiktoken"]
        assert config.heuristic["chars_per_token"] == 3.5
    
    def test_validation_empty_adapter(self):
        """Test validation fails with empty adapter."""
        with pytest.raises(ConfigError, match="Tokenizer adapter must be specified"):
            TokenizerConfig(adapter="")
    
    def test_validation_empty_model(self):
        """Test validation fails with empty model."""
        with pytest.raises(ConfigError, match="Tokenizer model must be specified"):
            TokenizerConfig(model="")
    
    def test_validation_negative_max_tokens(self):
        """Test validation fails with negative max_tokens."""
        with pytest.raises(ConfigError, match="max_tokens must be positive"):
            TokenizerConfig(max_tokens=-1)
    
    def test_validation_empty_fallback_chain(self):
        """Test validation fails with empty fallback chain."""
        with pytest.raises(ConfigError, match="Fallback chain must not be empty"):
            TokenizerConfig(fallback_chain=[])
    
    def test_validation_unknown_adapter_in_chain(self):
        """Test validation fails with unknown adapter in fallback chain."""
        with pytest.raises(ConfigError, match="Unknown adapter in fallback chain: unknown"):
            TokenizerConfig(fallback_chain=["tiktoken", "unknown", "heuristic"])
    
    def test_validation_invalid_heuristic_chars_per_token(self):
        """Test validation fails with invalid chars_per_token."""
        with pytest.raises(ConfigError, match="heuristic.chars_per_token must be a positive number"):
            TokenizerConfig(heuristic={"chars_per_token": -1.0})
    
    def test_validation_invalid_tiktoken_encoding(self):
        """Test validation fails with invalid tiktoken encoding."""
        with pytest.raises(ConfigError, match="tiktoken.encoding must be a string"):
            TokenizerConfig(tiktoken={"encoding": 123})
    
    def test_validation_invalid_huggingface_use_fast(self):
        """Test validation fails with invalid use_fast."""
        with pytest.raises(ConfigError, match="huggingface.use_fast must be a boolean"):
            TokenizerConfig(huggingface={"use_fast": "true"})
    
    def test_get_adapter_options(self):
        """Test getting adapter-specific options."""
        config = TokenizerConfig(
            heuristic={"chars_per_token": 3.5},
            tiktoken={"encoding": "cl100k_base"},
            huggingface={"use_fast": False},
            options={
                "heuristic": {"extra_option": "value"},
                "custom_adapter": {"custom_option": "value"}
            }
        )
        
        # Test heuristic options (merged)
        heuristic_opts = config.get_adapter_options("heuristic")
        assert heuristic_opts["chars_per_token"] == 3.5
        assert heuristic_opts["extra_option"] == "value"
        
        # Test tiktoken options
        tiktoken_opts = config.get_adapter_options("tiktoken")
        assert tiktoken_opts["encoding"] == "cl100k_base"
        
        # Test huggingface options
        hf_opts = config.get_adapter_options("huggingface")
        assert hf_opts["use_fast"] is False
        assert hf_opts["trust_remote_code"] is False
        
        # Test custom adapter options
        custom_opts = config.get_adapter_options("custom_adapter")
        assert custom_opts["custom_option"] == "value"
    
    def test_to_dict(self):
        """Test converting config to dictionary."""
        config = TokenizerConfig(
            adapter="tiktoken",
            model="gpt-4",
            max_tokens=8192
        )
        
        config_dict = config.to_dict()
        
        assert config_dict["adapter"] == "tiktoken"
        assert config_dict["model"] == "gpt-4"
        assert config_dict["max_tokens"] == 8192
        assert "fallback_chain" in config_dict
        assert "heuristic" in config_dict
        assert "tiktoken" in config_dict
        assert "huggingface" in config_dict
    
    def test_from_dict(self):
        """Test creating config from dictionary."""
        config_dict = {
            "adapter": "heuristic",
            "model": "bert-base-uncased",
            "max_tokens": 512,
            "fallback_chain": ["heuristic"],
            "heuristic": {"chars_per_token": 3.0}
        }
        
        config = TokenizerConfig.from_dict(config_dict)
        
        assert config.adapter == "heuristic"
        assert config.model == "bert-base-uncased"
        assert config.max_tokens == 512
        assert config.fallback_chain == ["heuristic"]
        assert config.heuristic["chars_per_token"] == 3.0


class TestTokenizerConfigLoader:
    """Test TokenizerConfigLoader class."""
    
    def test_read_toml_file_nonexistent(self):
        """Test reading non-existent TOML file returns empty dict."""
        result = TokenizerConfigLoader._read_toml_file(Path("nonexistent.toml"))
        assert result == {}
    
    def test_read_toml_file_valid(self):
        """Test reading valid TOML file."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".toml", delete=False) as f:
            f.write('''
adapter = "heuristic"
model = "test-model"

[heuristic]
chars_per_token = 3.5
''')
            f.flush()
            f.close()  # Close file before reading on Windows
            
            try:
                result = TokenizerConfigLoader._read_toml_file(Path(f.name))
                assert result["adapter"] == "heuristic"
                assert result["model"] == "test-model"
                assert result["heuristic"]["chars_per_token"] == 3.5
            finally:
                os.unlink(f.name)
    
    def test_read_json_file_valid(self):
        """Test reading valid JSON file with deprecation warning."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as f:
            json.dump({
                "adapter": "tiktoken",
                "model": "gpt-4"
            }, f)
            f.flush()
            f.close()  # Close file before reading on Windows
            
            try:
                with pytest.warns(DeprecationWarning, match="JSON config is deprecated"):
                    result = TokenizerConfigLoader._read_json_file(Path(f.name))
                assert result["adapter"] == "tiktoken"
                assert result["model"] == "gpt-4"
            finally:
                os.unlink(f.name)
    
    def test_apply_environment_overrides(self):
        """Test applying environment variable overrides."""
        config = {"adapter": "auto", "model": "default"}
        
        with patch.dict(os.environ, {
            f"{ENV_PREFIX}ADAPTER": "heuristic",
            f"{ENV_PREFIX}MODEL": "gpt-4",
            f"{ENV_PREFIX}MAX_TOKENS": "8192",
            f"{ENV_PREFIX}HEURISTIC_CHARS_PER_TOKEN": "3.5",
            f"{ENV_PREFIX}HUGGINGFACE_USE_FAST": "false",
            f"{ENV_PREFIX}HUGGINGFACE_TRUST_REMOTE_CODE": "true"
        }):
            result = TokenizerConfigLoader._apply_environment_overrides(config)
            
            assert result["adapter"] == "heuristic"
            assert result["model"] == "gpt-4"
            assert result["max_tokens"] == 8192
            assert result["heuristic"]["chars_per_token"] == 3.5
            assert result["huggingface"]["use_fast"] is False
            assert result["huggingface"]["trust_remote_code"] is True
    
    def test_apply_environment_overrides_invalid_max_tokens(self):
        """Test environment override with invalid max_tokens logs warning."""
        config = {"adapter": "auto"}
        
        with patch.dict(os.environ, {f"{ENV_PREFIX}MAX_TOKENS": "invalid"}):
            with patch("kano_backlog_core.tokenizer_config.logger") as mock_logger:
                result = TokenizerConfigLoader._apply_environment_overrides(config)
                
                # Should not set max_tokens and should log warning
                assert "max_tokens" not in result
                mock_logger.warning.assert_called_once()
    
    def test_load_from_dict(self):
        """Test loading config from dictionary with environment overrides."""
        config_dict = {"adapter": "auto", "model": "test-model"}
        
        with patch.dict(os.environ, {f"{ENV_PREFIX}ADAPTER": "heuristic"}):
            config = TokenizerConfigLoader.load_from_dict(config_dict)
            
            assert config.adapter == "heuristic"
            assert config.model == "test-model"
    
    def test_create_default_config(self):
        """Test creating default config with environment overrides."""
        with patch.dict(os.environ, {f"{ENV_PREFIX}MODEL": "custom-model"}):
            config = TokenizerConfigLoader.create_default_config()
            
            assert config.adapter == "auto"
            assert config.model == "custom-model"


class TestTokenizerConfigMigrator:
    """Test TokenizerConfigMigrator class."""
    
    def test_migrate_pipeline_config_basic(self):
        """Test migrating basic pipeline configuration."""
        old_config = {
            "tokenizer": {
                "adapter": "tiktoken",
                "model": "gpt-4",
                "max_tokens": 8192
            }
        }
        
        result = TokenizerConfigMigrator.migrate_pipeline_config(old_config)
        
        assert result["adapter"] == "tiktoken"
        assert result["model"] == "gpt-4"
        assert result["max_tokens"] == 8192
        assert result["fallback_chain"] == DEFAULT_CONFIG["fallback_chain"]
    
    def test_migrate_pipeline_config_with_options(self):
        """Test migrating pipeline configuration with adapter options."""
        old_config = {
            "tokenizer": {
                "adapter": "heuristic",
                "model": "test-model",
                "options": {
                    "chars_per_token": 3.5,
                    "encoding": "p50k_base",
                    "heuristic": {"extra_option": "value"},
                    "tiktoken": {"custom_option": "value"}
                }
            }
        }
        
        result = TokenizerConfigMigrator.migrate_pipeline_config(old_config)
        
        assert result["adapter"] == "heuristic"
        assert result["model"] == "test-model"
        assert result["heuristic"]["chars_per_token"] == 3.5
        assert result["heuristic"]["extra_option"] == "value"
        assert result["tiktoken"]["encoding"] == "p50k_base"
        assert result["tiktoken"]["custom_option"] == "value"
    
    def test_migrate_pipeline_config_empty(self):
        """Test migrating empty pipeline configuration uses defaults."""
        old_config = {}
        
        result = TokenizerConfigMigrator.migrate_pipeline_config(old_config)
        
        assert result["adapter"] == DEFAULT_CONFIG["adapter"]
        assert result["model"] == DEFAULT_CONFIG["model"]
        assert result["max_tokens"] == DEFAULT_CONFIG["max_tokens"]


class TestLoadTokenizerConfig:
    """Test load_tokenizer_config function."""
    
    def test_load_from_file(self):
        """Test loading config from file."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".toml", delete=False) as f:
            f.write('''
adapter = "heuristic"
model = "test-model"
''')
            f.flush()
            f.close()  # Close file before reading on Windows
            
            try:
                config = load_tokenizer_config(config_path=Path(f.name))
                assert config.adapter == "heuristic"
                assert config.model == "test-model"
            finally:
                os.unlink(f.name)
    
    def test_load_from_dict(self):
        """Test loading config from dictionary."""
        config_dict = {"adapter": "tiktoken", "model": "gpt-4"}
        
        config = load_tokenizer_config(config_dict=config_dict)
        assert config.adapter == "tiktoken"
        assert config.model == "gpt-4"
    
    def test_load_default(self):
        """Test loading default config."""
        config = load_tokenizer_config()
        assert config.adapter == "auto"
        assert config.model == "text-embedding-3-small"
    
    def test_load_both_path_and_dict_raises_error(self):
        """Test that specifying both config_path and config_dict raises error."""
        with pytest.raises(ConfigError, match="Cannot specify both config_path and config_dict"):
            load_tokenizer_config(config_path=Path("test.toml"), config_dict={})


class TestCreateExampleConfig:
    """Test create_example_config function."""
    
    def test_create_example_config(self):
        """Test creating example configuration."""
        example = create_example_config()
        
        assert isinstance(example, str)
        assert "adapter = \"auto\"" in example
        assert "model = \"text-embedding-3-small\"" in example
        assert "[tokenizer.heuristic]" in example
        assert "[tokenizer.tiktoken]" in example
        assert "[tokenizer.huggingface]" in example
        assert "KANO_TOKENIZER_ADAPTER" in example


class TestIntegration:
    """Integration tests for the configuration system."""
    
    def test_full_toml_config_workflow(self):
        """Test complete workflow with TOML configuration."""
        toml_content = '''
[tokenizer]
adapter = "heuristic"
model = "custom-model"
max_tokens = 1024
fallback_chain = ["heuristic", "tiktoken"]

[tokenizer.heuristic]
chars_per_token = 3.0

[tokenizer.huggingface]
use_fast = false
'''
        
        with tempfile.NamedTemporaryFile(mode="w", suffix=".toml", delete=False) as f:
            f.write(toml_content)
            f.flush()
            f.close()  # Close file before reading on Windows
            
            try:
                # Load configuration
                config = load_tokenizer_config(config_path=Path(f.name))
                
                # Verify configuration
                assert config.adapter == "heuristic"
                assert config.model == "custom-model"
                assert config.max_tokens == 1024
                assert config.fallback_chain == ["heuristic", "tiktoken"]
                assert config.heuristic["chars_per_token"] == 3.0
                assert config.huggingface["use_fast"] is False
                
                # Test adapter options
                heuristic_opts = config.get_adapter_options("heuristic")
                assert heuristic_opts["chars_per_token"] == 3.0
                
                hf_opts = config.get_adapter_options("huggingface")
                assert hf_opts["use_fast"] is False
                assert hf_opts["trust_remote_code"] is False  # Default value
                
            finally:
                os.unlink(f.name)
    
    def test_environment_override_integration(self):
        """Test environment variables override file configuration."""
        toml_content = '''
[tokenizer]
adapter = "tiktoken"
model = "gpt-3.5-turbo"
'''
        
        with tempfile.NamedTemporaryFile(mode="w", suffix=".toml", delete=False) as f:
            f.write(toml_content)
            f.flush()
            f.close()  # Close file before reading on Windows
            
            try:
                # Override with environment variables
                with patch.dict(os.environ, {
                    f"{ENV_PREFIX}ADAPTER": "heuristic",
                    f"{ENV_PREFIX}MODEL": "custom-model",
                    f"{ENV_PREFIX}MAX_TOKENS": "2048"
                }):
                    config = load_tokenizer_config(config_path=Path(f.name))
                    
                    # Environment variables should override file values
                    assert config.adapter == "heuristic"
                    assert config.model == "custom-model"
                    assert config.max_tokens == 2048
                    
            finally:
                os.unlink(f.name)