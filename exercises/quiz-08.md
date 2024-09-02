# Quiz 8: Non-Fungible Tokens (NFTs)

1. Which of the following is NOT a function required by the SIP009 NFT trait?
   a) get-last-token-id
   b) get-token-uri
   c) get-owner
   d) burn

2. True or False: The asset identifier for an NFT type must be an unsigned integer (`uint`).

3. What is an example of the correct way to assert conformity to the SIP009 NFT trait in a Clarity contract?
   a) (use-trait .sip009.trait)
   b) (implement-trait .sip009.trait)
   c) (impl-trait .sip009.trait)
   d) (assert-trait .sip009.trait)

4. In the context of SIP009 NFTs, what does the `get-token-uri` function typically return?
   a) The owner's principal
   b) The token's unique identifier
   c) A link to the token's metadata
   d) The token's transfer history

5. True or False: The SIP009 standard provides a specification for what should exist at the URI returned by `get-token-uri`.

6. In a typical SIP009 NFT implementation, what should the transfer function typically assert before allowing a token transfer? (Choose the most important check)
   a) The recipient has enough balance to receive the token
   b) The token ID is less than the last token ID
   c) The sender is equal to the `contract-caller`
   d) The sender is the contract owner

7. What does the error code `(err u1)` typically indicate when returned by the `nft-transfer?` function?
   a) The asset identifier does not exist
   b) The sender does not own the asset
   c) The sender and recipient are the same principal
   d) The NFT has already been minted

8. When attempting to mint an NFT, what is the most likely cause of receiving an `(err u1)` response?
   a) The NFT contract has reached its maximum supply
   b) The asset identifier already exists
   c) The recipient's address is invalid
   d) The contract caller is not authorized to mint

**Bonus Coding Challenges**

9. Debug this NFT transfer function error: `detected two execution paths, returning two different expression types`

   ```clojure
   (define-non-fungible-token CoolNFT uint)

   (define-public (transfer-nft (tokenId uint) (sender principal) (recipient principal))
     (begin
       (asserts! (is-eq tx-sender sender) (err u1))
       (try! (nft-transfer? CoolNFT tokenId sender recipient))
     )
   )

   ;; Test cases
   ;; (define-constant WALLET_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
   ;; (define-constant WALLET_2 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

   ;; (nft-mint? CoolNFT u1 WALLET_1)
   ;; (transfer-nft u1 WALLET_1 WALLET_2) ;; This should return (ok true)
   ;; (nft-get-owner? CoolNFT u1) ;; This should return (ok WALLET_2)
   ```

   [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1ub24tZnVuZ2libGUtdG9rZW4gQ29vbE5GVCB1aW50KQoKKGRlZmluZS1wdWJsaWMgKHRyYW5zZmVyLW5mdCAodG9rZW5JZCB1aW50KSAoc2VuZGVyIHByaW5jaXBhbCkgKHJlY2lwaWVudCBwcmluY2lwYWwpKQogIChiZWdpbgogICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgc2VuZGVyKSAoZXJyIHUxKSkKICAgICh0cnkhIChuZnQtdHJhbnNmZXI_IENvb2xORlQgdG9rZW5JZCBzZW5kZXIgcmVjaXBpZW50KSkKICApCikKCihkZWZpbmUtY29uc3RhbnQgV0FMTEVUXzEgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKQooZGVmaW5lLWNvbnN0YW50IFdBTExFVF8yICdTVDJDWTVWMzlOSERQV1NYTVc5UURUM0hDM0dENlE2WFg0Q0ZSSzlBRykKCjs7IFRlc3QgY2FzZXMKOzsgKG5mdC1taW50PyBDb29sTkZUIHUxIFdBTExFVF8xKQo7OyAodHJhbnNmZXItbmZ0IHUxIFdBTExFVF8xIFdBTExFVF8yKSA7OyBUaGlzIHNob3VsZCByZXR1cm4gKG9rIHRydWUpCjs7IChuZnQtZ2V0LW93bmVyPyBDb29sTkZUIHUxKSA7OyBUaGlzIHNob3VsZCByZXR1cm4gKG9rIFdBTExFVF8yKQ)

   [Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1ub24tZnVuZ2libGUtdG9rZW4gQ29vbE5GVCB1aW50KQoKKGRlZmluZS1wdWJsaWMgKHRyYW5zZmVyLW5mdCAodG9rZW5JZCB1aW50KSAoc2VuZGVyIHByaW5jaXBhbCkgKHJlY2lwaWVudCBwcmluY2lwYWwpKQogIChiZWdpbgogICAgKGFzc2VydHMhIChpcy1lcSB0eC1zZW5kZXIgc2VuZGVyKSAoZXJyIHUxKSkKICAgIChuZnQtdHJhbnNmZXI_IENvb2xORlQgdG9rZW5JZCBzZW5kZXIgcmVjaXBpZW50KQogICkKKQoKOzsgVGVzdHMgKHVuY29tbWVudCBhbmQgcnVuIHRoZXNlIHRvIGNoZWNrIHlvdXIgc29sdXRpb24pCjs7IChkZWZpbmUtY29uc3RhbnQgV0FMTEVUXzEgJ1NUMVBRSFFLVjBSSlhaRlkxREdYOE1OU05ZVkUzVkdaSlNSVFBHWkdNKQo7OyAoZGVmaW5lLWNvbnN0YW50IFdBTExFVF8yICdTVDJDWTVWMzlOSERQV1NYTVc5UURUM0hDM0dENlE2WFg0Q0ZSSzlBRykKCjs7IChuZnQtbWludD8gQ29vbE5GVCB1MSBXQUxMRVRfMSkKOzsgKHRyYW5zZmVyLW5mdCB1MSBXQUxMRVRfMSBXQUxMRVRfMikgOzsgVGhpcyBzaG91bGQgcmV0dXJuIChvayB0cnVlKQo7OyAobmZ0LWdldC1vd25lcj8gQ29vbE5GVCB1MSkgOzsgVGhpcyBzaG91bGQgcmV0dXJuIChvayBXQUxMRVRfMik)

10. Your task is to create a simple NFT lottery contract where users can purchase lottery tickets (as NFTs) by sending a certain amount of STX. Here are the requirements:

    - Define an NFT for lottery tickets
    - Create a function to purchase a ticket by sending STX
    - Create a function to select a winner (does not need to be random)
    - Allow the winner to claim their prize

    ```clojure
    (define-non-fungible-token Ticket uint)

    (define-data-var ticketCounter uint u0)
    (define-data-var ticketPrice uint u1000000) ;; 1 STX
    (define-data-var lotteryPool uint u0)

    (define-public (buy-ticket)
      ;; Implement ticket purchase logic here
    )

    (define-public (select-winner)
      ;; Implement winner selection logic here (this can be hard coded, or however you prefer)
    )

    (define-public (claim-prize)
      ;; Implement prize claiming logic here
    )

    ;; Test cases

    ;; Buy a ticket successfully
    ;; (contract-call? .lottery buy-ticket) ;; Should `mint` NFT to your address
    ;; ticketCounter should be 1, lotteryPool should be 1000000

    ;; Select a winner
    ;; (contract-call? .lottery select-winner)
    ;; Should return (ok principal) where principal is the winner's address

    ;; Claim prize (assuming the caller is the winner)
    ;; (contract-call? .lottery claim-prize) ;; Should return (ok u...)
    ;; The winner's balance should increase by 3000000, lotteryPool should be 0

    ;; Attempt to select winner when no tickets are sold
    ;; First, reset the contract state or deploy a fresh instance
    ;; (contract-call? .lottery select-winner)
    ;; Should return an error (err u...) indicating no tickets sold

    ;; Buy a ticket after a winner has been selected
    ;; Assuming a winner has been selected in a previous test
    ;; (contract-call? .lottery buy-ticket)
    ;; Should return an error (err u...) or start a new lottery round

    ;; Get current ticket price
    ;; (contract-call? .lottery get-ticket-price)
    ;; Should return price of ticket

    ;; Get total tickets sold
    ;; (contract-call? .lottery get-tickets-sold)
    ;; Should return the number of tickets sold (uint)

    ;; Get current lottery pool
    ;; (contract-call? .lottery get-lottery-pool)
    ;; Should return the current amount in the lottery pool (uint)
    ```

    [Problem](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1ub24tZnVuZ2libGUtdG9rZW4gVGlja2V0IHVpbnQpCgooZGVmaW5lLWRhdGEtdmFyIHRpY2tldENvdW50ZXIgdWludCB1MCkKKGRlZmluZS1kYXRhLXZhciB0aWNrZXRQcmljZSB1aW50IHUxMDAwMDAwKSA7OyAxIFNUWAooZGVmaW5lLWRhdGEtdmFyIGxvdHRlcnlQb29sIHVpbnQgdTApCgooZGVmaW5lLXB1YmxpYyAoYnV5LXRpY2tldCkKICA7OyBJbXBsZW1lbnQgdGlja2V0IHB1cmNoYXNlIGxvZ2ljIGhlcmUKKQoKKGRlZmluZS1wdWJsaWMgKHNlbGVjdC13aW5uZXIpCiAgOzsgSW1wbGVtZW50IHdpbm5lciBzZWxlY3Rpb24gbG9naWMgaGVyZSAodGhpcyBjYW4gYmUgaGFyZCBjb2RlZCwgb3IgaG93ZXZlciB5b3UgcHJlZmVyKQopCgooZGVmaW5lLXB1YmxpYyAoY2xhaW0tcHJpemUpCiAgOzsgSW1wbGVtZW50IHByaXplIGNsYWltaW5nIGxvZ2ljIGhlcmUKKQoKOzsgVGVzdCBjYXNlcwoKOzsgQnV5IGEgdGlja2V0IHN1Y2Nlc3NmdWxseQo7OyAoY29udHJhY3QtY2FsbD8gLmxvdHRlcnkgYnV5LXRpY2tldCkgOzsgU2hvdWxkIGBtaW50YCBORlQgdG8geW91ciBhZGRyZXNzCjs7IHRpY2tldENvdW50ZXIgc2hvdWxkIGJlIDEsIGxvdHRlcnlQb29sIHNob3VsZCBiZSAxMDAwMDAwCgo7OyBTZWxlY3QgYSB3aW5uZXIKOzsgKGNvbnRyYWN0LWNhbGw_IC5sb3R0ZXJ5IHNlbGVjdC13aW5uZXIpCjs7IFNob3VsZCByZXR1cm4gKG9rIHByaW5jaXBhbCkgd2hlcmUgcHJpbmNpcGFsIGlzIHRoZSB3aW5uZXIncyBhZGRyZXNzCgo7OyBDbGFpbSBwcml6ZSAoYXNzdW1pbmcgdGhlIGNhbGxlciBpcyB0aGUgd2lubmVyKQo7OyAoY29udHJhY3QtY2FsbD8gLmxvdHRlcnkgY2xhaW0tcHJpemUpIDs7IFNob3VsZCByZXR1cm4gKG9rIHUuLi4pCjs7IFRoZSB3aW5uZXIncyBiYWxhbmNlIHNob3VsZCBpbmNyZWFzZSBieSAzMDAwMDAwLCBsb3R0ZXJ5UG9vbCBzaG91bGQgYmUgMAoKOzsgQXR0ZW1wdCB0byBzZWxlY3Qgd2lubmVyIHdoZW4gbm8gdGlja2V0cyBhcmUgc29sZAo7OyBGaXJzdCwgcmVzZXQgdGhlIGNvbnRyYWN0IHN0YXRlIG9yIGRlcGxveSBhIGZyZXNoIGluc3RhbmNlCjs7IChjb250cmFjdC1jYWxsPyAubG90dGVyeSBzZWxlY3Qtd2lubmVyKQo7OyBTaG91bGQgcmV0dXJuIGFuIGVycm9yIChlcnIgdS4uLikgaW5kaWNhdGluZyBubyB0aWNrZXRzIHNvbGQKCjs7IEJ1eSBhIHRpY2tldCBhZnRlciBhIHdpbm5lciBoYXMgYmVlbiBzZWxlY3RlZAo7OyBBc3N1bWluZyBhIHdpbm5lciBoYXMgYmVlbiBzZWxlY3RlZCBpbiBhIHByZXZpb3VzIHRlc3QKOzsgKGNvbnRyYWN0LWNhbGw_IC5sb3R0ZXJ5IGJ1eS10aWNrZXQpCjs7IFNob3VsZCByZXR1cm4gYW4gZXJyb3IgKGVyciB1Li4uKSBvciBzdGFydCBhIG5ldyBsb3R0ZXJ5IHJvdW5kCgo7OyBHZXQgY3VycmVudCB0aWNrZXQgcHJpY2UKOzsgKGNvbnRyYWN0LWNhbGw_IC5sb3R0ZXJ5IGdldC10aWNrZXQtcHJpY2UpCjs7IFNob3VsZCByZXR1cm4gcHJpY2Ugb2YgdGlja2V0Cgo7OyBHZXQgdG90YWwgdGlja2V0cyBzb2xkCjs7IChjb250cmFjdC1jYWxsPyAubG90dGVyeSBnZXQtdGlja2V0cy1zb2xkKQo7OyBTaG91bGQgcmV0dXJuIHRoZSBudW1iZXIgb2YgdGlja2V0cyBzb2xkICh1aW50KQoKOzsgR2V0IGN1cnJlbnQgbG90dGVyeSBwb29sCjs7IChjb250cmFjdC1jYWxsPyAubG90dGVyeSBnZXQtbG90dGVyeS1wb29sKQo7OyBTaG91bGQgcmV0dXJuIHRoZSBjdXJyZW50IGFtb3VudCBpbiB0aGUgbG90dGVyeSBwb29sICh1aW50KQ)

    [Solution](https://play.hiro.so/?epoch=2.5&snippet=KGRlZmluZS1ub24tZnVuZ2libGUtdG9rZW4gVGlja2V0IHVpbnQpCgooZGVmaW5lLWRhdGEtdmFyIHRpY2tldENvdW50ZXIgdWludCB1MCkKKGRlZmluZS1kYXRhLXZhciB0aWNrZXRQcmljZSB1aW50IHUxMDAwMDAwKSA7OyAxIFNUWAooZGVmaW5lLWRhdGEtdmFyIGxvdHRlcnlQb29sIHVpbnQgdTApCihkZWZpbmUtZGF0YS12YXIgY3VycmVudFdpbm5lciAob3B0aW9uYWwgcHJpbmNpcGFsKSBub25lKQoKKGRlZmluZS1wdWJsaWMgKGJ1eS10aWNrZXQpCiAgKGxldCAKICAgICgKICAgICAgKGNhbGxlciB0eC1zZW5kZXIpCiAgICApCiAgICAoYXNzZXJ0cyEgKGlzLW5vbmUgKHZhci1nZXQgY3VycmVudFdpbm5lcikpIChlcnIgdTEwMCkpIDs7IEVuc3VyZSBubyB3aW5uZXIgaGFzIGJlZW4gc2VsZWN0ZWQKICAgICh0cnkhIChzdHgtdHJhbnNmZXI_ICh2YXItZ2V0IHRpY2tldFByaWNlKSBjYWxsZXIgKGFzLWNvbnRyYWN0IHR4LXNlbmRlcikpKQogICAgKHRyeSEgKG5mdC1taW50PyBUaWNrZXQgKHZhci1nZXQgdGlja2V0Q291bnRlcikgY2FsbGVyKSkKICAgICh2YXItc2V0IHRpY2tldENvdW50ZXIgKCsgKHZhci1nZXQgdGlja2V0Q291bnRlcikgdTEpKQogICAgKHZhci1zZXQgbG90dGVyeVBvb2wgKCsgKHZhci1nZXQgbG90dGVyeVBvb2wpICh2YXItZ2V0IHRpY2tldFByaWNlKSkpCiAgICAob2sgKHZhci1nZXQgdGlja2V0Q291bnRlcikpCiAgKQopCgooZGVmaW5lLXB1YmxpYyAoc2VsZWN0LXdpbm5lcikKICAobGV0CiAgICAoCiAgICAgICh0b3RhbC10aWNrZXRzICh2YXItZ2V0IHRpY2tldENvdW50ZXIpKQogICAgKQogICAgKGFzc2VydHMhICg-IHRvdGFsLXRpY2tldHMgdTApIChlcnIgdTEwMSkpIDs7IEVuc3VyZSB0aWNrZXRzIGhhdmUgYmVlbiBzb2xkCiAgICAoYXNzZXJ0cyEgKGlzLW5vbmUgKHZhci1nZXQgY3VycmVudFdpbm5lcikpIChlcnIgdTEwMikpIDs7IEVuc3VyZSBubyB3aW5uZXIgaGFzIGJlZW4gc2VsZWN0ZWQgeWV0CiAgICAobGV0CiAgICAgICgKICAgICAgICAod2lubmVyLXRpY2tldC1pZCAobW9kIGJsb2NrLWhlaWdodCB0b3RhbC10aWNrZXRzKSkKICAgICAgICAod2lubmVyICh1bndyYXAhIChuZnQtZ2V0LW93bmVyPyBUaWNrZXQgd2lubmVyLXRpY2tldC1pZCkgKGVyciB1MTAzKSkpCiAgICAgICkKICAgICAgKHZhci1zZXQgY3VycmVudFdpbm5lciAoc29tZSB3aW5uZXIpKQogICAgICAob2sgd2lubmVyKQogICAgKQogICkKKQoKKGRlZmluZS1wdWJsaWMgKGNsYWltLXByaXplKQogIChsZXQKICAgICgKICAgICAgKHdpbm5lciAodW53cmFwISAodmFyLWdldCBjdXJyZW50V2lubmVyKSAoZXJyIHUxMDQpKSkgOzsgRW5zdXJlIGEgd2lubmVyIGhhcyBiZWVuIHNlbGVjdGVkCiAgICAgIChwcml6ZSAodmFyLWdldCBsb3R0ZXJ5UG9vbCkpCiAgICApCiAgICAoYXNzZXJ0cyEgKGlzLWVxIHR4LXNlbmRlciB3aW5uZXIpIChlcnIgdTEwNSkpIDs7IEVuc3VyZSB0aGUgY2FsbGVyIGlzIHRoZSB3aW5uZXIKICAgICh0cnkhIChhcy1jb250cmFjdCAoc3R4LXRyYW5zZmVyPyBwcml6ZSB0eC1zZW5kZXIgd2lubmVyKSkpCiAgICAodmFyLXNldCBsb3R0ZXJ5UG9vbCB1MCkKICAgICh2YXItc2V0IGN1cnJlbnRXaW5uZXIgbm9uZSkKICAgICh2YXItc2V0IHRpY2tldENvdW50ZXIgdTApCiAgICAob2sgcHJpemUpCiAgKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LXRpY2tldC1wcmljZSkKICAob2sgKHZhci1nZXQgdGlja2V0UHJpY2UpKQopCgooZGVmaW5lLXJlYWQtb25seSAoZ2V0LXRpY2tldHMtc29sZCkKICAob2sgKHZhci1nZXQgdGlja2V0Q291bnRlcikpCikKCihkZWZpbmUtcmVhZC1vbmx5IChnZXQtbG90dGVyeS1wb29sKQogIChvayAodmFyLWdldCBsb3R0ZXJ5UG9vbCkpCik)
