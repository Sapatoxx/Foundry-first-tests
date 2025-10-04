// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../src/calculadora.sol";

import "forge-std/Test.sol";


contract calculadoratest is Test {
//El smart contrac de CalculadoraTes va a crear un smart contract llamado "calc"
  calculadora public calc; //Definimos la variable del contrato a testear, para poder usarla en todas las funciones del test  //Todavía no está desplegado
	uint256 public FirsResultado = 100; //Valor inicial del resultado
	address public admin = vm.addr(1); //La cuenta que ejecuta el test es el admin //vm.addr(1) está creando una cuenta/dirección random en función del número/parámetro que le pasamos //0x0000000001
	address public randomUser = vm.addr(2); //Otra cuenta que no es admin //0x0000000002

  //Necesitamos un "set up" para inicializar el contrato (es una función)
	function setUp () public {
      //Antes de cada test se ejecuta esta función
		calc = new calculadora(FirsResultado, admin);
	}

	//Unit testing -> Tenemos un input y checkeamos si el output es el esperado   // Testear un input a partir de un output
	function testCheckFirstResultado () public { //Siempre los tests empiezan con "test"
		uint256 FirstResultado_ = calc.resultado(); //Llamamos a la variable resultado del contrato
		assert(FirstResultado_ == FirsResultado); //El valor que esperamos que tenga resultado es 100
	}

	function testCheckAddition() public {
		uint256 FirsNumber_ = 10;
		uint256 SecondNumber_ = 10;
		uint256 resultado_ = calc.addition(FirsNumber_, SecondNumber_);
		assert(resultado_ == FirsNumber_ + SecondNumber_);
	}

	function testCheckSubstraction() public {
		uint256 FirstNumber_ = 5;
		uint256 SecondNumber_ = 2;
		uint256 resultado = calc.substraction(FirstNumber_, SecondNumber_);
		assert(resultado == FirstNumber_ - SecondNumber_);
	}

	function testCheckMultiplication() public {
		uint256 FirstNumber_ = 5;
		uint256 SecondNumber_ = 5;
		uint256 resultado = calc.multiplication(FirstNumber_, SecondNumber_);
		assert(resultado == FirstNumber_ * SecondNumber_);
	}

	function testCheckDivision() public {
		uint256 FirstNumber_ = 10;
		uint256 SecondNumber_ = 2;
		vm.prank(admin); //Hacemos que la siguiente llamada la haga el admin
		uint256 resultado = calc.division(FirstNumber_, SecondNumber_);
		assert(resultado == FirstNumber_ / SecondNumber_);
		vm.stopPrank(); //Parar de hacer llamadas como admin
	}

	//Tests para fallos
	function testCanNotMultiplyTwoLargeNumbers() public{
		uint256 LargeNumber=115792089237316195423570985008687907853269984665640564039457584007913129639934; //2^256 - 2
		uint256 smallNumer=2;
		vm.expectRevert(); //Esperamos que la siguiente llamada falle
		calc.multiplication(LargeNumber, smallNumer); //Esto va a fallar porque el resultado es mayor que 2^256 - 1
	}

	function testIfNotAdminCallsDivisionRevert() public {
		vm.startPrank(randomUser); //Hacemos que la siguiente llamada la haga randomUser (es decir, la cartera que no es admin)

		//DESDE startPrank HASTA stopPrank todas las llamadas las hace randomUser
		uint256 firstNumer_ = 10;
		uint256 secondNumber_ = 2;
		vm.expectRevert(); //Esperamos que la siguiente llamada falle
		calc.division(firstNumer_, secondNumber_); //Esto va a fallar porque randomUser no es admin
	
		vm.stopPrank(); //Parar de hacer llamadas como randomUser
	}

	function testAdminCanCallDivision() public{
		vm.startPrank(admin); //Hacemos que la siguiente llamada la haga admin

		//DESDE startPrank HASTA stopPrank todas las llamadas las hace admin
		uint256 firstNumer_ = 10;
		uint256 secondNumber_ = 2;
		calc.division(firstNumer_, secondNumber_);//Esto NO va a fallar porque la cartera que usamos para llamar a la función es admin
	
		vm.stopPrank(); //Parar de hacer llamadas como admin
	}

	function testUserCanNotCallDivision() public{
		vm.startPrank(randomUser); //Hacemos que la siguiente llamada la haga admin

		//DESDE startPrank HASTA stopPrank todas las llamadas las hace admin
		uint256 firstNumer_ = 10;
		uint256 secondNumber_ = 2;
		vm.expectRevert(); //Esperamos que la siguiente llamada falle
		calc.division(firstNumer_, secondNumber_);//Esto va a fallar porque la cartera que usamos para llamar a la función no es admin

		vm.stopPrank(); //Parar de hacer llamadas como admin
	}

	function testDivisionByZeroRevert() public{
		vm.startPrank(admin); //Hacemos que la siguiente llamada la haga admin

		uint256 firstNumer_ = 10;
		uint256 secondNumber_ = 0;
		vm.expectRevert(); //Esperamos que la siguiente llamada falle
		calc.division(firstNumer_, secondNumber_);//Esto va a fallar porque no se puede dividir por 0
	
		vm.stopPrank(); //Parar de hacer llamadas como admin
	}

	//Fuzzing testing ->Tenemos un test donde foundry se encarga de hacer Xs llamadas (las podemos definir nosotros) y esas llamadas usa parametros random (que también podemos definir nosotros) y checkea si el output es el esperado

	function testPassingDivision(uint256 FirtsNumber, uint256 SecondNumber) public {
		vm.startPrank(admin); 

		calc.division(FirtsNumber, SecondNumber);

		vm.stopPrank();
	}






}