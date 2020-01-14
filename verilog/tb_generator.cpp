#include<iostream>
#include<fstream>
#include<math.h>
#include<string>
#include<vector>
#define FB 4      
#define TB 8
// FB is number of floating bits
// TB is number of all bits

using namespace std;
string convert(double);
string two_complement(string);
string mapping(int);
string bin_to_hex(string);
int main(){
	ifstream ifsi;
	ofstream ifso;
	//ifsi.open("testx0.txt",ios::in);
	//ifso.open("fix_input_0.txt",ios::out|ios::trunc);
	ifsi.open("rlu1_golden.txt",ios::in);
	ifso.open("frlu1_golden.txt",ios::out|ios::trunc);
	//ifsi.open("rlu2_golden.txt",ios::in);
	//ifso.open("frlu2_golden.txt",ios::out|ios::trunc);
	//ifsi.open("k1.txt",ios::in);
	//ifso.open("fk1.txt",ios::out|ios::trunc);

	//ifsi.open("k2.txt",ios::in);
	//ifso.open("fk2.txt",ios::out|ios::trunc);	
	//ifsi.open("b1b2.txt",ios::in);
	//ifso.open("fb1b2.txt",ios::out|ios::trunc);
	double d;
	
	ifsi>>d;
	int count = 0;
	while(ifsi){
		d = d - fmod(d,pow(2,-FB));
		//if(d!=0)cout<<d<<endl;
		ifso<<convert(d);
		count++;
		if(count==4){
			count = 0;
			ifso<<"\n";
		}
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
	string a = mapping(decimal%16);
	string b = mapping((decimal>>4)%16);
	return pos?b+a:bin_to_hex(two_complement(b+a).substr(0,4))+bin_to_hex(two_complement(b+a).substr(4,4));
}
string bin_to_hex(string bin){
	if(bin=="0000")
		return "0";
	else if(bin=="0001")
		return "1"; 
	else if(bin=="0010")
		return "2"; 
	else if(bin=="0011")
		return "3"; 
	else if(bin=="0100")
		return "4"; 
	else if(bin=="0101")
		return "5"; 
	else if(bin=="0110")
		return "6"; 
	else if(bin=="0111")
		return "7"; 
	else if(bin=="1000")
		return "8"; 
	else if(bin=="1001")
		return "9"; 
	else if(bin=="1010")
		return "A"; 
	else if(bin=="1011")
		return "B"; 
	else if(bin=="1100")
		return "C";
	else if(bin=="1101")
		return "D";  
	else if(bin=="1110")
		return "E"; 
	else if(bin=="1111")
		return "F"; 
	return "";
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
string map_bin(char in){
	string a; 
	if(in=='0')
		a = "0000";
	else if(in=='1')
		a = "0001";
	else if(in=='2')
		a = "0010";
	else if(in=='3')
		a = "0011";
	else if(in=='4')
		a = "0100";
	else if(in=='5')
		a = "0101";
	else if(in=='6')
		a = "0110";
	else if(in=='7')
		a = "0111";
	else if(in=='8')
		a = "1000";
	else if(in=='9')
		a = "1001";
	else if(in=='A')
		a = "1010";
	else if(in=='B')
		a = "1011";
	else if(in=='C')
	 	a = "1100";
	else if(in=='D')
		a = "1101";
	else if(in=='E')
		a = "1110";
	else 
		a = "1111";
	return a;
}
string two_complement(string posexp){
	string bin = map_bin(posexp[0])+map_bin(posexp[1]);
	
	int carry = 1;
	// inversing
	for(int i = 0; i < bin.size(); ++i){
		bin[i] = bin[i]=='1'?'0':'1';
	}
	// plus one
	for(int i = bin.size()-1; i >= 0; --i){
		if(carry==1&&bin[i]=='1'){
			bin[i] = '0';
		}else if(carry==1&&bin[i]=='0'){
			bin[i] = '1';
			carry = 0;
		}
	}
	return bin;
}
