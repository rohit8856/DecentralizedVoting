pragma solidity ^0.8.0;

contract Storage{
    
    address public mainperson;
    
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    struct proposal{
        address proposaladd;
        bytes32 name;
        uint votecount;
    }
    
    Proposal[] public Proposals;
    
    mapping(address => Voter) public voters;
    mapping(address =>proposals) public proposals;
    
    
    
    constructor(address _mainperson, bytes32[] memory proposals){
        
        mainperson = _mainperson;
        voters[mainperson].weight = 1;
        for(uint i=0;i< Proposals.length;i++){
            Proposals.push(Proposal({
                name: Proposalname[i],
                votecount :0
            }));
        }
    }
    
    modifier onlymainperson(){
        require(msg.sender == mainperson, "Storage: controller fuction");
        _;
    }
    
    modifier initialized(){
        require(mainperson != address(0), "Storage : Required address of mainperson");
        _;
    }
    
    
    
    
    
}