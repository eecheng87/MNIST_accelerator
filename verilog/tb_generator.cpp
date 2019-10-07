#include<iostream>
#include<fstream>
#include<math.h>
#include<vector>
#define FB 4      
#define TB 8
// FB is number of floating bits
// TB is number of all bits

using namespace std;
string convert(double);
int two_complement(int);
string mapping(int);

int main(){
	ifstream ifsi;
	ofstream ifso;
	//ifsi.open("../test_data/testx0.txt",ios::in);
	//ifso.open("fix_input_0.txt",ios::out|ios::trunc);
	//ifsi.open("rlu1_golden.txt",ios::in);
	//ifso.open("frlu1_golden.txt",ios::out|ios::trunc);
	ifsi.open("rlu2_golden.txt",ios::in);
	ifso.open("frlu2_golden.txt",ios::out|ios::trunc);
	double d;
	
	ifsi>>d;
	while(ifsi){
		d = d - fmod(d,pow(2,-FB));
		if(d!=0)cout<<d<<endl;
		ifso<<convert(d)<<endl;
		ifsi>>d;
	}
	ifsi.close();
	ifso.close();


	return 0;
} 
string convert(double d){
	string ans;
	bool pos = (d>=0)?true:false;
	d = pos?d:-d;
	int decimal = 0;
	
 
	decimal = d/pow(2,-FB);
	//if(decimal!=0)cout<<decimal<<endl;
	decimal = pos?decimal:two_complement(decimal);
	string a = mapping(decimal%16);
	string b = mapping((decimal>>4)%16);
	//if(b+a!="00")cout<<b+a<<endl;
	return b+a;
}
string mapping(int decimal){
	switch(decimal){
		case 0:
			return "0";
		case 1:
			return "1";
		case 2:
			return "2";
		case 3:
			return "3";
		case 4:
			return "4";
		case 5:
			return "5";
		case 6:
			return "6";
		case 7:
			return "7";
		case 8:
			return "8";
		case 9:
			return "9";
		case 10:
			return "A";
		case 11:
			return "B";
		case 12:
			return "C";
		case 13:
			return "D";
		case 14:
			return "E";
		case 15:
			return "F";
	}
}
int two_complement(int decimal){
	return (~decimal)+1;
}
