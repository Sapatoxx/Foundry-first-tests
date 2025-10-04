// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract calculadora {
	//Variables
    uint256 public resultado;
	address public admin;
    
	//Events
	event Addition(uint256 FirstNumber_, uint256 SecondNumber_, uint256 resultado_);
	event Substraction(uint256 FirstNumber_, uint256 SecondNumber_, uint256 resultado_);
	event Multiplication(uint256 FirstNumber_, uint256 SecondNumber_, uint256 resultado_);
	event Division(uint256 FirstNumber_, uint256 SecondNumber_, uint256 resultado_);

	//Modifiers
	modifier onlyAdmin() {
		require(msg.sender == admin, "Only admin can perform this action");
		_;
	}
    constructor(uint256 FirstResultado_, address admin_) {
        resultado = FirstResultado_;
		admin = admin_;
    }
    //Addition  
	function addition(uint256 num1_, uint256 num2_) external returns (uint256 resultado_) {
		resultado_= num1_ + num2_;
		resultado = resultado_;
		emit Addition(num1_, num2_, resultado_);
	}
    
    //Subtraction
	function substraction(uint256 num1_, uint256 num2_) external returns (uint256 resultado_) {
		resultado_= num1_-num2_;
		resultado = resultado_;
		emit Substraction(num1_, num2_, resultado_);
	}

    //Multiplication
	function multiplication(uint256 num1_, uint256 num2_) external returns (uint256 resultado_) {
		resultado_= num1_*num2_;
		resultado = resultado_;
		emit Multiplication(num1_, num2_, resultado_);
	}

    //Division
	function division(uint256 num1_, uint256 num2_) external onlyAdmin returns  (uint256 resultado_) {
    if(num2_ == 0) return 0; //Si el número 2 es 0, devolvemos 0
		resultado_= num1_/num2_;
		resultado = resultado_;
		emit Division(num1_, num2_, resultado_);
	}
}
