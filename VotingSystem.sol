// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Struct to store candidates' names and vote counts
    struct Candidate {
        string name;
        uint voteCount;
    }

    mapping(address => bool) public hasVoted; // Track if an address has voted
    Candidate[] public candidates; // Array to store candidates
    address public owner;
    bool public votingOpen;

    // Constructor - initializes the voting options
    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        votingOpen = true;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }

    // Function to close voting, only accessible by the contract owner
    function closeVoting() public {
        require(msg.sender == owner, "Only the owner can close voting.");
        votingOpen = false;
    }

    // Function to cast a vote
    function vote(uint candidateIndex) public {
        require(votingOpen, "Voting is closed.");
        require(!hasVoted[msg.sender], "You have already voted.");
        require(candidateIndex < candidates.length, "Invalid candidate index.");

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
    }

    // Function to get the winner after voting has closed
    function getWinner() public view returns (string memory winnerName) {
        require(!votingOpen, "Voting is still open.");
        
        uint winningVoteCount = 0;
        uint winningIndex = 0;
        
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningIndex = i;
            }
        }
        
        winnerName = candidates[winningIndex].name;
    }
}
