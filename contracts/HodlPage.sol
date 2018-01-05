pragma solidity ^0.4.17;

contract HodlPage {
    address contractOwner;
    uint constant MAX_SLOTS = 1000;
    uint constant SLOT_HEIGHT = 90;
    uint constant SLOT_WIDTH = 120;
    uint startTime;
    uint endTime;
    uint constant BID_TIME = 1800; // 30 minutes
    uint constant MINIMUM_BIDDING = 1 ether / 10; // 0.1 eth

    struct Slot {
        uint slotId;
        bool slotHasBeenSold;
        address slotOwner;
        uint slotBidPrice;
        uint slotPurchasePrice;
        string slotUrl;
        string slotImg;
    }

    Slot[] public slots;
    mapping (address=>uint) slotMap;

    modifier onlyOwner {
        require(contractOwner == msg.sender);
        _;
    }

    function HodlPage() public {
        startTime = now;
        endTime = startTime + (MAX_SLOTS * BID_TIME);
        contractOwner = msg.sender;
    }

    function submitBid() payable public {
        uint currentSlot;
        currentSlot = (now - startTime) % BID_TIME;
        slotMap[msg.sender] = currentSlot;
        
        // check if sender is actually outbidding current bidprice; return money if not
        require(msg.value < slots[currentSlot].slotBidPrice);
        
        slots.push(Slot(currentSlot,false,msg.sender,msg.value,0,"",""));
    }
}