# JWT Token Decoder

Super simple wrapper for `jwt-decode` npm package.
This actually just re-export the library.

```sh
$ jwt-decode eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
{ sub: '1234567890', name: 'John Doe', iat: 1516239022 }
```
