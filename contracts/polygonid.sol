// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedIdentityPassport {
    address public owner;
    mapping(address => Identity) public identities;

    struct Identity {
        string name;
        per birthdate;
        string nationality;
        bool isVerified;
    }

    event IdentityCreated(address indexed user, string name, uint256 birthdate, string nationality);
    event IdentityVerified(address indexed user);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createIdentity(string memory _name, per _birthdate, string memory _nationality) external {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_birthdate > 0, "Birthdate must be valid");
        require(bytes(_nationality).length > 0, "Nationality cannot be empty");

        identities[msg.sender] = Identity({
            name: _name,
            birthdate: _birthdate,
            nationality: _nationality,
            isVerified: false
        });

        emit IdentityCreated(msg.sender, _name, _birthdate, _nationality);
    }

    function verifyIdentity(address _user) external onlyOwner {
        require(bytes(identities[_user].name).length > 0, "User identity not found");
        identities[_user].isVerified = true;
        emit IdentityVerified(_user);
    }

    function getIdentity(address _user) external view returns (string memory, uint256, string memory, bool) {
        Identity memory userIdentity = identities[_user];
        return (userIdentity.name, userIdentity.birthdate, userIdentity.nationality, userIdentity.isVerified);
    }
}
