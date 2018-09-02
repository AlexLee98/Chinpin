pragma solidity ^0.4.24;

/** @title Token contract */
contract Token {
    
    /** @dev Property of all tokens */
    string public constant name = "Token";
    string public constant symbol = "TOK";
    address eventContract;
    uint256 eventID;
    string eventDescription;
    uint256 totalSupply;
    bool minted;
    
    /** @dev Mapping maps a user's address to the user's balance */
    mapping (address => uint256) public balanceOf;  
    mapping (address => mapping (address => uint256)) public allowance;
    
    /** @dev Event for notifying the user whenever tokens are transfered */
    event Transfer (address indexed _sender, address indexed _recipient, uint256 _numTokens);
    
    /** @dev Event for notifying the user whenever token withdrawing is allowed */
    event Approval (address indexed _owner, address indexed _spender, uint256 _numTokens);
    
    /** @dev This function is made to mint numTokens number of tokens with a specified name and symbol.
      * @param _numTokens  Number of tokens to mint
      */
    function mintTokens (uint256 _numTokens, uint256 _eventID, string _eventDescription) public {
        require(minted == false);
        totalSupply = _numTokens;  
        eventContract = msg.sender;
        eventID = _eventID;
        eventDescription = _eventDescription;
        minted = true;
        balanceOf[msg.sender] = totalSupply;    
        emit Transfer(msg.sender, msg.sender, _numTokens);
    }
    
    /** @dev This function is made to transfer numTokens tokens from a specified sender to a recipient.
      * @param _sender     The address of the sender
      * @param _recipient  The address of the recipient
      * @param _numTokens  Number of tokens to transfer
      */
    function _transfer (address _sender, address _recipient, uint256 _numTokens) private returns (bool success) {
        require(_recipient != 0x0);                       
        require(balanceOf[_sender] >= _numTokens);         
        balanceOf[_sender] -= _numTokens;                 
        balanceOf[_recipient] += _numTokens;               
        emit Transfer(_sender, _recipient, _numTokens);
        return true;
    }
    
    /** @dev This function transfers tokens from the user calling it to a specified recipient.
      * @param _recipient  Who to transfer tokens to.
      * @param _numTokens  Number of tokens to transfer.
      */
    function transfer (address _recipient, uint256 _numTokens) public {
        _transfer(msg.sender, _recipient, _numTokens);
    }
    
     /** @dev This function transfers tokens from a specified user to a recipient.
      * @param _sender     Who to transfer tokens from.
      * @param _recipient  Who to transfer tokens to.
      * @param _numTokens  Number of tokens to transfer.
      */
    function transferFrom (address _sender, address _recipient, uint256 _numTokens) public {
        _transfer(_sender, _recipient, _numTokens);
    } 
    
    /** @dev This function returns the balance of a token owner.
    * @param _tokenOwner  The address of the tokenOwner.
    */
    function balanceOf(address _tokenOwner) public view returns (uint balance) {
        return balanceOf[_tokenOwner];
    }
    
    /** @dev Returns the amount of tokens in circulation */
    function getNumTokens () public constant returns (uint256 numTokens) {
        return totalSupply;
    }
    
    /** @dev This function allows a user to spend numTokens amount of tokens.
      * @param _spender    Address of who you allow to spend tokens
      * @param _numTokens  Number of tokens to allow user to spend
      */
    function approve (address _spender, uint256 _numTokens) public returns (bool success) {
        allowance[msg.sender][_spender] = _numTokens;
        emit Approval(msg.sender, _spender, _numTokens);
        return true;
    }
    
    /** @dev This function returns the amount of allowance that a spender has.
      * @param _owner    Address of the owner
      * @param _spender  Address of the spender
      */
    function allowance (address _owner, address _spender) public view returns (uint256 numTokens) {
        return allowance[_owner][_spender];
    }
    
    function tokenInfo() public view returns (uint256 _totalSupply, uint256 _eventID, string _eventDescription, address _eventContract) {
        return (totalSupply, eventID, eventDescription, eventContract);
    }
}

