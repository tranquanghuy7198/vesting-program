/* SPDX-License-Identifier: UNLICENSED */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./VIKToken.sol";

contract Vesting is Ownable {
    using SafeMath for uint256;

    struct Program {
        uint8 id;
        string name;
        uint256 totalAllocation;
        uint256 availableAmount;
        uint256[55] releaseSchedule;
    }

    struct VestingInfo {
        uint256 claimedAmount;
        mapping(uint8 => uint256) atProgram;
    }

    uint256 public TGE;
    VIKToken public VIK;
    Program[] public allPrograms;
    uint256 private _MONTH;
    address private _paymentWallet;
    mapping(address => bool) private _operators;
    mapping(address => VestingInfo) private _vestingInfoOf;

    event ParticipantRegistered(
        address participant,
        uint8 programId,
        uint256 amount
    );
    event TGEStarted();
    event ClaimSuccessful(address participant, uint256 amount);
    event EmergencyWithdraw(address recipient, uint256 amount);

    constructor(address vikToken, address paymentWallet) Ownable() {
        TGE = 0;
        _MONTH = 10 * 60;
        VIK = VIKToken(vikToken);
        _paymentWallet = paymentWallet;
        _operators[msg.sender] = true;
        uint256 decimals = VIK.decimals();
        allPrograms.push(
            Program(
                0,
                "Seed Round",
                27200000,
                27200000 * 10**decimals,
                [
                    uint256(1360000),
                    272000,
                    272000,
                    272000,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    2085333,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                1,
                "Private Sale",
                81600000,
                81600000 * 10**decimals,
                [
                    uint256(6528000),
                    1632000,
                    1632000,
                    1632000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    5848000,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                2,
                "Public Sale",
                6800000,
                6800000 * 10**decimals,
                [
                    uint256(6800000),
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                3,
                "Staking Reward",
                68000000,
                68000000 * 10**decimals,
                [
                    uint256(0),
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    1360000,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                4,
                "Game Reward",
                204000000,
                204000000 * 10**decimals,
                [
                    uint256(0),
                    0,
                    2040000,
                    2040000,
                    2040000,
                    2040000,
                    2040000,
                    2040000,
                    3060000,
                    3060000,
                    3060000,
                    3060000,
                    3060000,
                    3060000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    4080000,
                    10200000
                ]
            )
        );
        allPrograms.push(
            Program(
                5,
                "Advisors",
                27200000,
                27200000 * 10**decimals,
                [
                    uint256(0),
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    1133333,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                6,
                "Team",
                34000000,
                34000000 * 10**decimals,
                [
                    uint256(0),
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    1416667,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                7,
                "Game Ecosystem",
                34000000,
                34000000 * 10**decimals,
                [
                    uint256(0),
                    0,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    680000,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                8,
                "Liquidity",
                40800000,
                40800000 * 10**decimals,
                [
                    uint256(40800000),
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                9,
                "Operating Fund",
                68000000,
                68000000 * 10**decimals,
                [
                    uint256(3400000),
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    3400000,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
        allPrograms.push(
            Program(
                10,
                "Marketing",
                88400000,
                88400000 * 10**decimals,
                [
                    uint256(4420000),
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    4420000,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
                ]
            )
        );
    }

    modifier onlyOperator() {
        require(_operators[msg.sender], "Caller is not operator");
        _;
    }

    function getNumPrograms() external view returns (uint256) {
        return allPrograms.length;
    }

    function getVestingAmount(address participant, uint8 programId)
        external
        view
        returns (uint256)
    {
        return _vestingInfoOf[participant].atProgram[programId];
    }

    function getClaimedAmount(address participant)
        external
        view
        returns (uint256)
    {
        return _vestingInfoOf[participant].claimedAmount;
    }

    function getClaimableAmount(address participant)
        public
        view
        returns (uint256)
    {
        require(TGE > 0, "TGE not launched yet");
        uint256 totalUnlockedAmount = 0;
        uint256 currentMonth = block.timestamp.sub(TGE).div(_MONTH);
        for (uint8 i = 0; i < allPrograms.length; i++) {
            Program memory program = allPrograms[i];
            uint256 totalRelease = 0;
            for (uint256 month = 0; month <= currentMonth; month++)
                totalRelease = totalRelease.add(program.releaseSchedule[month]);
            uint256 unlockedAmount = _vestingInfoOf[participant]
                .atProgram[i]
                .mul(totalRelease)
                .div(program.totalAllocation);
            totalUnlockedAmount = totalUnlockedAmount.add(unlockedAmount);
        }
        return
            totalUnlockedAmount.sub(_vestingInfoOf[participant].claimedAmount);
    }

    function setOperator(address operator, bool isOperator) external onlyOwner {
        _operators[operator] = isOperator;
    }

    function registerParticipant(
        address participant,
        uint8 programId,
        uint256 amount
    ) external onlyOperator {
        require(participant != address(0), "Register the zero address");
        require(programId < allPrograms.length, "Program does not exist");
        Program storage program = allPrograms[programId];
        require(amount <= program.availableAmount, "Not enough amount");
        _vestingInfoOf[participant].atProgram[programId] = _vestingInfoOf[
            participant
        ].atProgram[programId].add(amount);
        program.availableAmount = program.availableAmount.sub(amount);
        VIK.transferFrom(_paymentWallet, address(this), amount);
        emit ParticipantRegistered(participant, programId, amount);
    }

    function startTGE() external onlyOperator {
        require(TGE == 0, "TGE already launched");
        TGE = block.timestamp;
        emit TGEStarted();
    }

    function claimTokens() external {
        uint256 claimableAmount = getClaimableAmount(msg.sender);
        _vestingInfoOf[msg.sender].claimedAmount = _vestingInfoOf[msg.sender]
            .claimedAmount
            .add(claimableAmount);
        VIK.transfer(msg.sender, claimableAmount);
        emit ClaimSuccessful(msg.sender, claimableAmount);
    }

    function emergencyWithdraw(address recipient) external onlyOwner {
        uint256 amount = VIK.balanceOf(address(this));
        VIK.transfer(recipient, amount);
        emit EmergencyWithdraw(recipient, amount);
    }
}
