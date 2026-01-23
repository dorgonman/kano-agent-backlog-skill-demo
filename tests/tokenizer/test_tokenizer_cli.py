"""Tests for tokenizer CLI commands."""

import json
import tempfile
from pathlib import Path
from unittest.mock import patch, MagicMock

import pytest
from typer.testing import CliRunner

from kano_backlog_cli.commands.tokenizer_cmd import app


class TestTokenizerCLI:
    """Test tokenizer CLI commands."""
    
    def setup_method(self):
        """Set up test fixtures."""
        self.runner = CliRunner()
    
    def test_config_command_json_output(self):
        """Test config command with JSON output."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_config = MagicMock()
            mock_config.to_dict.return_value = {
                "adapter": "auto",
                "model": "text-embedding-3-small",
                "max_tokens": None
            }
            mock_load.return_value = mock_config
            
            result = self.runner.invoke(app, ["config", "--format", "json"])
            
            assert result.exit_code == 0
            config_data = json.loads(result.stdout)
            assert config_data["adapter"] == "auto"
            assert config_data["model"] == "text-embedding-3-small"
    
    def test_config_command_with_config_path(self):
        """Test config command with specific config path."""
        config_path = Path("test_config.toml")
        
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_config = MagicMock()
            mock_config.to_dict.return_value = {"adapter": "heuristic"}
            mock_load.return_value = mock_config
            
            result = self.runner.invoke(app, ["config", "--config", str(config_path)])
            
            assert result.exit_code == 0
            mock_load.assert_called_once_with(config_path=config_path)
    
    def test_config_command_toml_output_missing_dependency(self):
        """Test config command with TOML output when tomli_w is missing."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_config = MagicMock()
            mock_config.to_dict.return_value = {"adapter": "auto"}
            mock_load.return_value = mock_config
            
            with patch.dict("sys.modules", {"tomli_w": None}):
                result = self.runner.invoke(app, ["config", "--format", "toml"])
                
                assert result.exit_code == 1
                assert "tomli_w package required" in result.stderr
    
    def test_config_command_unsupported_format(self):
        """Test config command with unsupported format."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_config = MagicMock()
            mock_load.return_value = mock_config
            
            result = self.runner.invoke(app, ["config", "--format", "xml"])
            
            assert result.exit_code == 1
            assert "Unsupported format 'xml'" in result.stderr
    
    def test_validate_command_success(self):
        """Test validate command with valid configuration."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_config = MagicMock()
            mock_config.adapter = "heuristic"
            mock_config.model = "test-model"
            mock_config.max_tokens = None
            mock_config.fallback_chain = ["heuristic", "tiktoken"]
            mock_load.return_value = mock_config
            
            result = self.runner.invoke(app, ["validate"])
            
            assert result.exit_code == 0
            assert "✓ Configuration is valid" in result.stdout
            assert "Adapter: heuristic" in result.stdout
            assert "Model: test-model" in result.stdout
            assert "Max tokens: auto" in result.stdout
    
    def test_validate_command_failure(self):
        """Test validate command with invalid configuration."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_load.side_effect = Exception("Invalid configuration")
            
            result = self.runner.invoke(app, ["validate"])
            
            assert result.exit_code == 1
            assert "✗ Configuration validation failed" in result.stderr
    
    def test_test_command_success(self):
        """Test test command with successful adapter testing."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            with patch("kano_backlog_core.tokenizer.get_default_registry") as mock_registry:
                # Mock configuration
                mock_config = MagicMock()
                mock_config.fallback_chain = ["heuristic", "tiktoken"]
                mock_config.model = "test-model"
                mock_config.max_tokens = None
                mock_config.adapter = "auto"
                mock_config.get_adapter_options.return_value = {}
                mock_load.return_value = mock_config
                
                # Mock registry and adapters
                mock_reg_instance = MagicMock()
                mock_registry.return_value = mock_reg_instance
                
                # Mock heuristic adapter
                mock_heuristic_adapter = MagicMock()
                mock_heuristic_adapter.count_tokens.return_value = MagicMock(
                    count=10, method="heuristic", tokenizer_id="heuristic:test", is_exact=False
                )
                mock_heuristic_adapter.max_tokens.return_value = 8192
                
                # Mock tiktoken adapter failure
                mock_reg_instance._create_adapter.side_effect = [
                    mock_heuristic_adapter,  # heuristic succeeds
                    Exception("tiktoken not available")  # tiktoken fails
                ]
                
                # Mock primary adapter resolution
                mock_primary_adapter = MagicMock()
                mock_primary_adapter.adapter_id = "heuristic"
                mock_primary_adapter.count_tokens.return_value = MagicMock(
                    count=10, is_exact=False
                )
                mock_reg_instance.resolve.return_value = mock_primary_adapter
                
                result = self.runner.invoke(app, ["test", "--text", "test text"])
                
                assert result.exit_code == 0
                assert "✓ HEURISTIC Adapter:" in result.stdout
                assert "✗ TIKTOKEN Adapter failed:" in result.stdout
                assert "Primary adapter resolution" in result.stdout
    
    def test_create_example_command(self):
        """Test create-example command."""
        with tempfile.TemporaryDirectory() as temp_dir:
            output_path = Path(temp_dir) / "example_config.toml"
            
            with patch("kano_backlog_core.tokenizer_config.create_example_config") as mock_create:
                mock_create.return_value = "# Example configuration\nadapter = \"auto\""
                
                result = self.runner.invoke(app, ["create-example", "--output", str(output_path)])
                
                assert result.exit_code == 0
                assert "✓ Created example tokenizer configuration" in result.stdout
                assert output_path.exists()
                
                content = output_path.read_text(encoding="utf-8")
                assert "adapter = \"auto\"" in content
    
    def test_create_example_command_file_exists(self):
        """Test create-example command when file already exists."""
        with tempfile.NamedTemporaryFile(suffix=".toml", delete=False) as f:
            f.close()  # Close file before using it
            try:
                result = self.runner.invoke(app, ["create-example", "--output", f.name])
                
                assert result.exit_code == 1
                assert "File already exists" in result.stderr
            finally:
                Path(f.name).unlink()
    
    def test_create_example_command_force_overwrite(self):
        """Test create-example command with force overwrite."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".toml", delete=False) as f:
            f.write("existing content")
            f.flush()
            f.close()  # Close file before using it
            
            try:
                with patch("kano_backlog_core.tokenizer_config.create_example_config") as mock_create:
                    mock_create.return_value = "# New example configuration"
                    
                    result = self.runner.invoke(app, ["create-example", "--output", f.name, "--force"])
                    
                    assert result.exit_code == 0
                    assert "✓ Created example tokenizer configuration" in result.stdout
                    
                    content = Path(f.name).read_text(encoding="utf-8")
                    assert "New example configuration" in content
            finally:
                Path(f.name).unlink()
    
    def test_migrate_command_success(self):
        """Test migrate command with successful migration."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as input_file:
            with tempfile.NamedTemporaryFile(suffix=".toml", delete=False) as output_file:
                # Write input JSON config
                json.dump({"tokenizer": {"adapter": "heuristic"}}, input_file)
                input_file.flush()
                input_file.close()  # Close input file
                
                # Close and remove output file so it doesn't exist initially
                output_file.close()
                Path(output_file.name).unlink()
                
                try:
                    with patch("kano_backlog_core.tokenizer_config.TokenizerConfigMigrator") as mock_migrator:
                        result = self.runner.invoke(app, [
                            "migrate", 
                            input_file.name, 
                            "--output", 
                            output_file.name
                        ])
                        
                        assert result.exit_code == 0
                        assert "✓ Migrated configuration" in result.stdout
                        mock_migrator.migrate_file.assert_called_once()
                finally:
                    Path(input_file.name).unlink()
                    if Path(output_file.name).exists():
                        Path(output_file.name).unlink()
    
    def test_migrate_command_input_not_found(self):
        """Test migrate command when input file doesn't exist."""
        result = self.runner.invoke(app, ["migrate", "nonexistent.json"])
        
        assert result.exit_code == 1
        assert "Input file not found" in result.stderr
    
    def test_migrate_command_output_exists(self):
        """Test migrate command when output file already exists."""
        with tempfile.NamedTemporaryFile(suffix=".json", delete=False) as input_file:
            with tempfile.NamedTemporaryFile(suffix=".toml", delete=False) as output_file:
                input_file.close()  # Close files before using them
                output_file.close()
                
                try:
                    result = self.runner.invoke(app, [
                        "migrate", 
                        input_file.name, 
                        "--output", 
                        output_file.name
                    ])
                    
                    assert result.exit_code == 1
                    assert "Output file already exists" in result.stderr
                finally:
                    Path(input_file.name).unlink()
                    Path(output_file.name).unlink()
    
    def test_env_command(self):
        """Test env command shows environment variables."""
        result = self.runner.invoke(app, ["env"])
        
        assert result.exit_code == 0
        assert "KANO_TOKENIZER_ADAPTER" in result.stdout
        assert "KANO_TOKENIZER_MODEL" in result.stdout
        assert "KANO_TOKENIZER_MAX_TOKENS" in result.stdout
        assert "Override adapter selection" in result.stdout
        assert "Example usage:" in result.stdout
    
    def test_config_command_load_error(self):
        """Test config command when configuration loading fails."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_load.side_effect = Exception("Configuration error")
            
            result = self.runner.invoke(app, ["config"])
            
            assert result.exit_code == 1
            assert "Error loading tokenizer configuration" in result.stderr
    
    def test_test_command_config_error(self):
        """Test test command when configuration loading fails."""
        with patch("kano_backlog_core.tokenizer_config.load_tokenizer_config") as mock_load:
            mock_load.side_effect = Exception("Configuration error")
            
            result = self.runner.invoke(app, ["test"])
            
            assert result.exit_code == 1
            assert "Error testing tokenizer adapters" in result.stderr
    
    def test_migrate_command_migration_error(self):
        """Test migrate command when migration fails."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False) as input_file:
            json.dump({"tokenizer": {"adapter": "heuristic"}}, input_file)
            input_file.flush()
            input_file.close()  # Close file before using it
            
            try:
                with patch("kano_backlog_core.tokenizer_config.TokenizerConfigMigrator") as mock_migrator:
                    mock_migrator.migrate_file.side_effect = Exception("Migration failed")
                    
                    result = self.runner.invoke(app, ["migrate", input_file.name])
                    
                    assert result.exit_code == 1
                    assert "Error migrating configuration" in result.stderr
            finally:
                Path(input_file.name).unlink()