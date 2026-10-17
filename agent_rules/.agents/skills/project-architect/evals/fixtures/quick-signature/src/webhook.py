import hashlib
import hmac
import json


def verify_signature(raw_body: bytes, signature: str, secret: bytes) -> bool:
    expected = hmac.new(secret, raw_body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, signature)


def handle_webhook(raw_body: bytes, signature: str, secret: bytes) -> dict:
    if not verify_signature(raw_body, signature, secret):
        raise ValueError("Invalid signature")

    return json.loads(raw_body)
