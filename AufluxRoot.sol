pragma solidity ^0.5.1;

contract AufluxRoot {
    
    event ContractUpgrade(address newContract);

    address public ceoAddress;
    address payable public cfoAddress;
    address public cooAddress;
    
    constructor() public {
        ceoAddress = msg.sender;
    }
   
    bool public paused = false;

    
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }
    
    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }
    
    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }
    
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    function setCFO(address payable _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused {
        require(paused);
        _;
    }

    function pause() external payable onlyCLevel whenNotPaused {
        paused = true;
    }

    function unpause() public payable onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}
