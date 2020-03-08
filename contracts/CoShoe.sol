pragma solidity >= 0.5.0;

import "/Users/derickkazimoto/Desktop/FinTech_and_Cryptocurrencies/Co's/contracts/Co.sol";

contract CoShoe is Co {
    
    struct Shoe{
        address owner;
        string name;
        string image;
        bool sold;
    }
    
    //address public minter;
    //mapping(address => uint) public tokens;
    
    //uint public price = 0.5 ether;
    uint public shoesSold = 0;
    Shoe[] public shoe;

    constructor() public{
        minter = msg.sender;
        //Minter mints 100 tokens
        //tokens[minter] = 100; //Tokens are minted in the Co Contract
    }

    //function used to check the amount of Tokens minted by minter at the begining of the contract
    //function noOfTokens() public view returns (uint){
    //    return tokens[minter];
    //}

    //buyShoe() used to buy and customize shoes
    // A digital copy of the shoe is made as a non-fungoble token is created
    //.. with a unique name and image
    function buyShoe(address caller, string memory _name, string memory _image, uint amount) public payable{
        //This function can only mint 100 tokens
        require(shoesSold <= 100,"Sold Out of Shoes");
        //Checks if address of caller owns atleast one token to make a purchase of a shoe
        require(balanceOf(caller) > 0, "Should buy tokens first");
        //A buyer choses the name and image of the shoe by putting the below inputs
        shoe.push(Shoe({
            owner: msg.sender,
            name: _name,
            image: _image,
            sold: true
        }));
        //Onwer of the contract allows the caller to spend tokens
        allowance(minter,caller);

        //Approve transaction
        approve(caller,amount);

        //transfers "amount" of tokens from account to owner of contract
        transferFrom(caller,minter, amount);

        //A pair of shoe is sold
        shoesSold++;
    }

    function checkPurchases(address caller) public returns(bool[] memory) {
         //Checks if caller of function is msg.sender
        require(caller == msg.sender,"checkPurchases for caller function");
        //Creates a new array of boolean values called trueBool
        bool[] memory trueBool = new bool[](shoesSold);

        //A for loop is used to loop through shoe
       for (uint i = 0;i < shoesSold;i++) {
           Shoe storage shoes = shoe[i];
           if (shoes.owner == caller){
               shoes.sold = true;
               trueBool[i] = true;
           }
           else{
               shoes.sold = false;
               trueBool[i] = false;
           }
       }
       //An array of boolean values is returned
       return trueBool;
    }
}