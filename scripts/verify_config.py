from kano_backlog_core.config import ConfigLoader

try:
    # Valid
    ConfigLoader.validate_pipeline_config({})
    print("Empty config valid.")
    
    # Invalid
    ConfigLoader.validate_pipeline_config({"tokenizer": {"adapter": "bad"}})
except ValueError as e:
    print(f"Caught expected error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
