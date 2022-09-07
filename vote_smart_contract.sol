//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract Ballot {

    struct Proposal {
        string name;
        uint voteCount;
    }

    struct Voter {
        uint vote;
        bool isVoted;
        uint weight;
    }

    Proposal[] public proposals;

    mapping(address => Voter) public votersList;

    address public electionCommissioner;

    constructor(string[] memory proposalNames) {
        electionCommissioner = msg.sender;
        votersList[electionCommissioner].weight = 1;

        for(uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function authenticateVoter(address voter) public {
        require(electionCommissioner == msg.sender, "You are not authorized to access this data!");
        require(!votersList[voter].isVoted, "You have already claimed your vote!");
        require(votersList[voter].weight == 0);

        votersList[voter].weight = 1;
    }

    function vote(uint proposalName) public {
        Voter storage sender = votersList[msg.sender];
        require(sender.weight != 0, "You have no right to Vote!");
        require(!sender.isVoted, "You have already claimed your vote!");
        sender.isVoted = true;
        sender.vote = proposalName;

        proposals[proposalName].voteCount += sender.weight;
    }

    function winnerInProposals() public view returns(uint winner) {
        uint winnerVoteCount = 0;

        for(uint i = 0; i < proposals.length; i++) {
            if(proposals[i].voteCount > winnerVoteCount) {
                winnerVoteCount = proposals[i].voteCount;
                winner = i;
            }
        }
    }

    function winnerName() public view returns(string memory winnerName_) {
        winnerName_ = proposals[winnerInProposals()].name;
    }
}
