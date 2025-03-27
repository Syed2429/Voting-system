// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

contract VotingSystem {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public admin;
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    event VoteCasted(address voter, string candidate);

    constructor(string[] memory _candidateNames) {
        admin = msg.sender;
        for (uint i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({name: _candidateNames[i], voteCount: 0}));
        }
    }

    function vote(uint256 _candidateIndex) external {
        require(!hasVoted[msg.sender], "You have already voted!");
        require(_candidateIndex < candidates.length, "Invalid candidate index!");

        hasVoted[msg.sender] = true;
        candidates[_candidateIndex].voteCount += 1;

        emit VoteCasted(msg.sender, candidates[_candidateIndex].name);
        console.log("Voter address: %s voted for %s", msg.sender, candidates[_candidateIndex].name);
    
    }

    function getWinner() external view returns (string memory) {
        uint256 highestVotes = 0;
        uint256 winnerIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}
