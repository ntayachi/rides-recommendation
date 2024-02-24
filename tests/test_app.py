import pytest
from  app.app import app

def test_app_health_check():
    response = app.test_client().get("/health")
    assert response.status_code == 200
    assert response.data.decode("utf-8") == "OK"

