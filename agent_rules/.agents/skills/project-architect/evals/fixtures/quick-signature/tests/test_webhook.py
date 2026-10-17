import hashlib
import hmac
import unittest

from src.webhook import handle_webhook


class SignatureInputTest(unittest.TestCase):
    def test_original_whitespace_is_signed(self):
        secret = b"fixture-only-secret"
        raw_body = b'{ "delivery_id" : "d-1" }\n'
        signature = hmac.new(secret, raw_body, hashlib.sha256).hexdigest()

        self.assertEqual(handle_webhook(raw_body, signature, secret), {"delivery_id": "d-1"})

        with self.assertRaises(ValueError):
            handle_webhook(b'{"delivery_id":"d-1"}', signature, secret)
