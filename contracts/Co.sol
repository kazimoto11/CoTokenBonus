pragma solidity >= 0.5.0;

import "/Users/derickkazimoto/Desktop/FinTech_and_Cryptocurrencies/Co/openzeppelin-contracts-master/contracts/token/ERC20/ERC20.sol";
import "/Users/derickkazimoto/Desktop/FinTech_and_Cryptocurrencies/Co/openzeppelin-contracts-master/contracts/ownership/Ownable.sol";

contract Co is Ownable, ERC20{

    //Minter is the owner of the contract and the address is payable
    address payable public minter;

    //mintedTokens is used as a counter of amount of tokens minted
    //Initialized as zero at the begining of the contract
    uint public mintedTokens = 0;

    constructor() public{
        minter = msg.sender;
    }

    //Fallback function so as the contract can accept ether
    fallback() external payable{

    }

    receive() external payable{
        
    }
    
    // Function that fetches the buying price of coTokens from the bonding curve
    // f(x) = 0.01x + 0.2
    //The price is in ether
    function buyPrice(uint nCoTokens) public view returns(uint){
        //nCoTokens - Amount of CoTokens
        //Check if the required number of coTokens is available;
        require((100 - mintedTokens) >= nCoTokens, "Exceeded the amount of nCoTokens available");
        //Price of tokens given a supply of nCoTokens requested
        uint buyValue = ((0.01 ether * nCoTokens) + (0.2 ether));
        //returns the buyValue of number of coTokens requested in wei
        return buyValue;
    }
    
    function sellPrice(uint nCoTokens) public pure returns (uint){
        //nCoTokens - Amount of CoTokens
        //Sell value price at a given supply of CoTokens requested
        uint sellValue = ((0.01 ether * nCoTokens) + (0.2 ether));
        //return the sellvalue of number of coTokens requested in wei
        return sellValue;
    }
    
    function mint(address account, uint nCoTokens) public payable {
        //function that checks the number of coTokens to be mintedToken given a certain amount of ether
        //account- Address of customer wanting to mint tokens
        //nCoTokens - Amount of CoTokens

        //Checks if 100 CoTokens have been minted
        //Only 100 CoTokens are required
        require(mintedTokens <= 100,"Only 100 tokens to be minted");
        
        //Checks if account has attached the correct amount of ether to be sent to the owner of the contract
        require(buyPrice(nCoTokens) == msg.value, "Enter exact amount for tokens buyPrice() function");
        
        //Sends amount paid by account to mint the tokens to the owner of the contract
        minter.transfer(msg.value);
        
        // Mints the number of Cotokens paid by account and credits the address
        _mint(account, nCoTokens);

        //Adds the count of minted CoTokens to keep track when 100 tokens have been minted
        mintedTokens += nCoTokens;
    }

    //mintedCoins() is used in test 1 to return the number minted tokens from account
    function mintedCoins(address account, uint nCoTokens) public {
        return _mint(account, nCoTokens);
    }
    
    function burn(address account, uint nCoTokens) public onlyOwner payable{
        //Only owner can call this function
        //account - address of the owner which is minter
        //amount - number of tokens owner/minter wants to burn

        //ERC20 _burn function owner burns tokens
        _burn(account,nCoTokens);
        
        //amount ether owner sends to self by burning down tokens
        minter.transfer(sellPrice(nCoTokens));
        
        //The total number of minted tokens burned reduced the mintedTokens counter
        mintedTokens -= nCoTokens;
    }
    function destroy() public onlyOwner{
        //Only owner can call this function

        //Checks if all CoTokens are owned by minter before destroying the contract
        require(balanceOf(minter) == 100, "For owner needs to own all tokens to destroy the contract");

        //Uses the self destruct function to destroy the contract
        selfdestruct(minter);
    }
}
