pragma solidity ^0.4.24;

contract Token {
    
    //Public variables for all tokens
    uint256 value;
    uint256 totalSupply;
    string public name;
    string public symbol;
    
    //Balance of each account 
    mapping (address => uint256) public balanceOf;  
    mapping (address => mapping (address => uint256)) public allowance;
    
    //Notify for successful transfer of tokens
    event Transfer (address indexed _sender, address indexed _recipient, uint256 _numTokens);
    
    //Notify user of approval 
    event Approval (address indexed _owner, address indexed _spender, uint256 _numTokens);
    
    //Mint n number of tokens with specified name and symbol
    function mintTokens (uint256 numTokens, string tokenName, string tokenSymbol) public {
        totalSupply = numTokens;                    
        name = tokenName;                           
        symbol = tokenSymbol;
        balanceOf[msg.sender] = totalSupply;        //Give creator all tokens    
        value = 1;                                  //Initial value is 1:1 (1 token for 1 usd)
    }
    
    // Transfer n tokens from sender to recipient
    function _transfer (address _sender, address _recipient, uint256 _numTokens) private returns (bool success) {
        require(_recipient != 0x0);                        //Don't send to 0x0
        require(balanceOf[_sender] >= _numTokens);         //Need sender to have enough tokens
        balanceOf[_sender] -= _numTokens;                  //Subtract balance of sender
        balanceOf[_recipient] += _numTokens;               //Add balance to recipient
        emit Transfer(_sender, _recipient, _numTokens);
        return true;
    }
    
    //Return balance of tokenOwner
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balanceOf[tokenOwner];
    }
    
    //Transfer n tokens from minter to recipient
    function transfer (address _recipient, uint256 _numTokens) public {
        _transfer(msg.sender, _recipient, _numTokens);
    }
    
    //Transfer n tokens from sender to recipient
    function transferFrom (address _sender, address _recipient, uint256 _numTokens) public {
        _transfer(_sender, _recipient, _numTokens);
    } 
    
    //Return number of tokens in circulation
    function getNumTokens () public constant returns (uint256 numTokens) {
        return totalSupply;
    }
    
    //Allow spender to spend up to "_numTokens" amount of tokens
    function approve (address _spender, uint256 _numTokens) public returns (bool success) {
        allowance[msg.sender][_spender] = _numTokens;
        emit Approval(msg.sender, _spender, _numTokens);
        return true;
    }
    
    //Returns number of tokens that owner allows spender to spend
    function allowance (address _owner, address _spender) public view returns (uint256 numTokens) {
        return allowance[_owner][_spender];
    }
    
    //Change value of token
    function changeValue (uint256 _value) public {
        value = _value;
    }
}
