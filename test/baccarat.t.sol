// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ThreeCardsMain} from "../src/3laMain.sol";
import {ThreeCardsMainGet} from "../src/3laGet.sol";

contract CounterTest is Test {
    ThreeCardsMain public MAIN;
    ThreeCardsMainGet public GET;
    address public Deployer = address(0x1);
    address public userA = address(0x2);
    address public userB = address(0x3);
    address public userC = address(0x4);
    address public userD = address(0x5);
    address public userE = address(0x6);
    uint256 currentTime = 1732162789;
    constructor() public {
        vm.startPrank(Deployer);
        MAIN = new ThreeCardsMain();
        GET = new ThreeCardsMainGet(address(MAIN));
        vm.stopPrank();

    }

    function testPlay() public {
        //userA create room 1
        vm.startPrank(userA);
        vm.deal(userA, 5 ether);
        uint256 registerTime = 300;
        uint256 bidAmount = 1000;
        uint256 _playersAmount = 10;
        MAIN.CreateRoom{value:9000}(registerTime, bidAmount, _playersAmount);
        vm.stopPrank();
        // vm.warp(currentTime+100); // 3/10/2024

        //userB join room 1
        vm.startPrank(userB);
        vm.deal(userB, 5 ether);
        MAIN.register{value:1000}(1);
        vm.stopPrank();

        //userC join room 1
        vm.startPrank(userC);
        vm.deal(userC, 5 ether);
        MAIN.register{value:1000}(1);
        vm.stopPrank();

        //userD join room 1
        vm.startPrank(userD);
        vm.deal(userD, 5 ether);
        MAIN.register{value:1000}(1);
        vm.stopPrank();

        //userE join room 1
        vm.startPrank(userE);
        vm.deal(userE, 5 ether);
        MAIN.register{value:1000}(1);
        vm.stopPrank();

        //admin setDeck
        uint after1Mins = currentTime+60;
        vm.warp(after1Mins);
        string[52] memory encodedArray = ["BhJi","Glk=","thQ=","TVE=","Et4=","d3Tq","1fQ=","Vmw=","t/U=","hiY=","vEc=","EY4=","dGY=","1co=","mmQ=","I9g=","MZ0=","QtY=","plE=","CJU=","fnA=","Y+c=","I2s=","nu0=","M80=","86E=","lNc=","Buk=","Oms=","mS4=","O90=","rRPM","ZNA=","M90=","Xiw=","3Rw=","3NA=","PjI=","3gQ=","CNOS","Lkc=","bQY=","0T0=","hwg=","Aww=","DW4=","Tes=","28E=","PQ0=","s1c=","csg=","+Rs="];
        string[] memory dynamicArray = new string[](encodedArray.length);
        for (uint256 i = 0; i < encodedArray.length; i++) {
            dynamicArray[i] = encodedArray[i];
        }
        vm.startPrank(Deployer);
        MAIN.setDeck(1,dynamicArray);
        ThreeCardsMain.PlayerCopy memory playerA = MAIN.getAPlayerBytes(1,userA);
        bytes memory card = playerA.cards[0];
        assertTrue(playerA.cards[0].length >0 && playerA.cards[1].length >0 && playerA.cards[2].length >0);
        vm.stopPrank();

        //userA choose players to compare
        vm.startPrank(userA);
        address[] memory chosenArr = new address[](4);
        chosenArr[0] = userB;
        chosenArr[1] = userC;
        chosenArr[2] = userD;
        chosenArr[3] = userE;
        MAIN.chosePlayerCompare(1, chosenArr);
        vm.stopPrank();

        //service hoac admin comfirm user A va B . chu y: C- tep, D- Do, H- Co,S- Bich 
        vm.startPrank(Deployer);
        string[] memory decodedKeyA = new string[](3);
        decodedKeyA[0] = "1f0a3959bf2a55eaebf3d4bc4e9cadbf";
        decodedKeyA[1] = "60cdd35b6425928150634417196fedab";
        decodedKeyA[2] = "2ea432f83e035576515d25acfffe497a";
        string[] memory decodedCardsArrA = new string[](3);
        decodedCardsArrA[0] = "KD"; //K Do
        decodedCardsArrA[1] = "1D"; //1 Do
        decodedCardsArrA[2] = "3H"; //3 Co -> tong =14 -> so cuoi = 4
        MAIN.comfirm(1, userA, decodedKeyA, decodedCardsArrA);

        string[] memory decodedKeyC = new string[](3);
        decodedKeyC[0] = "2f0a3959bf2a55eaebf3d4bc4e9cadbf";
        decodedKeyC[1] = "70cdd35b6425928150634417196fedab";
        decodedKeyC[2] = "3ea432f83e035576515d25acfffe497a";
        string[] memory decodedCardsArrC = new string[](3);
        decodedCardsArrC[0] = "KD"; //K Do
        decodedCardsArrC[1] = "QD"; //Q Do
        decodedCardsArrC[2] = "JH"; //J Co -> tong =30, ko co 10 -> so cuoi = 10
        MAIN.comfirm(1, userC, decodedKeyC, decodedCardsArrC);

        string[] memory decodedKeyD = new string[](3);
        decodedKeyD[0] = "3f0a3959bf2a55eaebf3d4bc4e9cadbf";
        decodedKeyD[1] = "80cdd35b6425928150634417196fedab";
        decodedKeyD[2] = "4ea432f83e035576515d25acfffe497a";
        string[] memory decodedCardsArrD = new string[](3);
        decodedCardsArrD[0] = "1S"; //K Do
        decodedCardsArrD[1] = "5D"; //Q Do
        decodedCardsArrD[2] = "3H"; //J Co -> tong =9 -> so cuoi = 9
        MAIN.comfirm(1, userD, decodedKeyD, decodedCardsArrD);

        string[] memory decodedKeyE = new string[](3);
        decodedKeyE[0] = "4f0a3959bf2a55eaebf3d4bc4e9cadbf";
        decodedKeyE[1] = "90cdd35b6425928150634417196fedab";
        decodedKeyE[2] = "5ea432f83e035576515d25acfffe497a";
        string[] memory decodedCardsArrE = new string[](3);
        decodedCardsArrE[0] = "10S"; //K Do
        decodedCardsArrE[1] = "5D"; //Q Do
        decodedCardsArrE[2] = "7H"; //J Co -> tong =22 -> so cuoi = 2
        MAIN.comfirm(1, userE, decodedKeyE, decodedCardsArrE);

        string[] memory decodedKeyB = new string[](3);
        decodedKeyB[0] = "b7d466deabf9c8e5a77ceb32b9a0dd8e"; 
        decodedKeyB[1] = "abcdb3f34ad4e6ea49e5ded69cabf108";
        decodedKeyB[2] = "b4056629cc6c995ce3c51cbb2b50fb66";
        string[] memory decodedCardsArrB = new string[](3);
        decodedCardsArrB[0] = "6C"; //6Tep      
        decodedCardsArrB[1] = "QS"; //QBich
        decodedCardsArrB[2] = "4S"; //4Bich  -> tong =20 -> so cuoi = 0
        (,ThreeCardsMain.RoomCopy[] memory activeRooms) = GET.GetActiveRoom(1);
        ThreeCardsMain.PlayerCopy[] memory playersRoom1 = activeRooms[0].playersArr;
        bytes[]  memory decodedCardsUserA = playersRoom1[0].decodedCards;
        assertEq(decodedCardsUserA.length,3,"should be equal");
        assertTrue(decodedCardsUserA[0].length>0 && decodedCardsUserA[1].length>0 && decodedCardsUserA[2].length>0);
        MAIN.comfirm(1, userB, decodedKeyB, decodedCardsArrB);
        ThreeCardsMain.RoomCopy memory room1 = MAIN.convert(1);
        playersRoom1 = room1.playersArr;
        decodedCardsUserA = playersRoom1[0].decodedCards;
        assertEq(decodedCardsUserA.length,3,"should be equal");
        assertTrue(decodedCardsUserA[0].length>0 && decodedCardsUserA[1].length>0 && decodedCardsUserA[2].length>0);
        ThreeCardsMain.PlayerCopy[] memory players = MAIN.getPlayersBytesAroom(1);
        assertEq(4,players[0].lastDigit,"userA should be 4");
        assertEq(0,players[1].lastDigit,"userB should be 0");
        assertEq(10,players[2].lastDigit,"userC should be 10");
        assertEq(9,players[3].lastDigit,"userD should be 9");
        assertEq(2,players[4].lastDigit,"userE should be 2");

        assertEq(false,players[1].win,"userB should be lose");
        assertEq(true,players[2].win,"userC should be win");
        assertEq(true,players[3].win,"userD should be win");
        assertEq(false,players[4].win,"userE should be lose");

        assertEq(MAIN.balanceOfwithdrawFunds(userA), 9000,"should be equal");
        assertEq(MAIN.balanceOfwithdrawFunds(userB), 0,"should be equal");
        assertEq(MAIN.balanceOfwithdrawFunds(userC), 2000,"should be equal");
        assertEq(MAIN.balanceOfwithdrawFunds(userD), 2000,"should be equal");
        assertEq(MAIN.balanceOfwithdrawFunds(userE), 0,"should be equal");
        vm.stopPrank();

        vm.startPrank(userA);
        assertEq(userA.balance,5 ether - 9000,"should be equal");
        MAIN.withdrawFund();
        assertEq(userA.balance,5 ether,"should be equal");
        vm.stopPrank();
    }

}
