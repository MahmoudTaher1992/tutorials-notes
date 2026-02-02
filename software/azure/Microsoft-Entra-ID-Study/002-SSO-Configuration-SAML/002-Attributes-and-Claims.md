# Attributes & Claims (The Payload)

## Key Concepts
*   **i. User Identifier (NameID):** Deciding what to send as the unique key (usually `user.userPrincipalName` or email).
*   **ii. Group Claims:** The critical configuration to send Group Membership data inside the SAML token so the SP knows what permissions to grant.
*   **iii. Custom Claims:** Mapping specific IdP attributes (e.g., Department, Cost Center) to SAML attributes expected by the SP.
*   **iv. [NEW] Claims Transformations:** Using the "Join" or "Extract" functions to format data (e.g., stripping `@domain.com` from a username before sending).
