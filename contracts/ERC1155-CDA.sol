// SPDX-License-Identifier: CC-BY-4.0
// 2021 Ninja Dynamics

// solhint-disable compiler-version
// solhint-disable func-visibility

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SmartContract {
    bool public constant IS_CONTRACT = true;
}

struct DigitalAsset {
    SmartContract dapp;
    address creator;
    uint256 content;
    uint256 license;
    uint256 totalSupply;
    uint256[] components;
    uint8 permissions;
    string name;
}

contract ERC1155_CDA is ERC1155 {

    using SafeMath for uint;

    event AssetCreated(address indexed _creator, uint256 indexed _id);

    // To maintain backwards compatibility with existing ERC1155 interfaces
    string internal constant ERC1155_URI = "https://game.example/api/item/{id}.json";

    DigitalAsset[] assets;

    function _create(
        string memory _name,
        address _dapp,
        uint256 _content,
        uint256 _license,
        uint256 _totalSupply,
        uint8 _permissions,
        uint256[] memory _components
    ) internal returns (uint256 index) {
        DigitalAsset memory asset;
        asset.name = _name;
        asset.dapp = SmartContract(_dapp);
        asset.creator = msg.sender;
        asset.content = _content;
        asset.license = _license;
        asset.totalSupply = _totalSupply;
        asset.permissions = _permissions;
        asset.components = _components;
        assets.push(asset);
        index = assets.length - 1;
        emit AssetCreated(msg.sender, index);
    }

    function _mint(address _owner, uint256 _id, uint256 _amount) internal {
        require(_id < assets.length, "ASSET NOT FOUND");
        DigitalAsset storage asset = assets[_id];
        require(_amount <= asset.totalSupply, "NOT ENOUGH QUANTITY");
        asset.totalSupply = asset.totalSupply.sub(_amount);
        _mint(_owner, _id, _amount);
    }

    // TODO: Add asset modification functions based on the permissions set by the owner

    constructor() ERC1155(ERC1155_URI) {

    }
}
