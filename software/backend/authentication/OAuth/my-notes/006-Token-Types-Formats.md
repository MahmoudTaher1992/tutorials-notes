# Token-Types-Formats
*   Types of token formats


---

### Bearer Tokens (RFC 6750)
*   **"Any party in possession of the token (the 'bearer') can use it to get access to the associated resources."**

---

### JWT Access Tokens (RFC 9068)
*   self-contained
    *    It carries all the necessary information (user ID, permissions, expiration) inside the token itself.
*   Stateless
    *   the client can validate it's signeture without calling the AS

---

### Opaque Tokens
*   An opaque token is a proprietary handle or identifier
*   to the client application 
    *   contains no meaningful data in and of itself.
*   AS is always needed to validate it and to get info about it

---

### Proof-of-Possession (PoP) Tokens
*   it is a Bearer Tokens signed by a secret key with the client
*   No one takes the token can use it unless he takes the key with it