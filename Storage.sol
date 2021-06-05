pragma solidity ^0.8.0;

contract Storage{
    
    
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    struct Proposal{
        bytes32 name;
        uint votecount;
    }
    
    address public mainperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    
    constructor(bytes32[] memory Proposalname) public{
        mainperson = msg.sender;
        voters[mainperson].weight = 1;
        for(uint i=0;i< Proposalname.length;i++){
            proposals.push(Proposal({
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
    
    
    function righttovote(address voter) public returns(bool){
        require(
            msg.sender == mainperson ,"only mainperson can give right to vote");
    
        require(!voters[voter].voted, " Voter already voted");
    
        require(voters[voter].weight == 0);
        voters[voter].weight =1;
        return true;
    }
    
    
    function delegateto(address toaccess)public  {
        Voter storage voter = voters[msg.sender];
        require(!voter.voted," You already voted");
        
        require( toaccess != msg.sender,"Self delegation is not allowed");
        
        
        while(voters[toaccess].delegate != address(0)){
            
            toaccess = voters[toaccess].delegate;
            require( toaccess != msg.sender);
        }
        
        voter.voted = true;
        voter.delegate = toaccess;
        Voter  storage _delegate = voters[toaccess];
        if(_delegate.voted){
            proposals[_delegate.vote].votecount += voter.weight;
        }
        else{
            _delegate.weight += voter.weight;
        }
    }
    
    function vote (uint proposal) public{
        Voter storage voter = voters[msg.sender];
        require(!voter.voted," You are done with the process");
        voter.voted = true;
        voter.vote = proposal;
        
        proposals[proposal].votecount += voter.weight;
    }
    
    
    function winingproposal() public view returns(uint _winingproposal){
        uint finalcount =0;
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].votecount > finalcount){
                finalcount = proposals[i].votecount;
                _winingproposal = i;
            }
        }
    }
        
       function AndTheWinnerIs() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winingproposal()].name;
    }
    }
        
    