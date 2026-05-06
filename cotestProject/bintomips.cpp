#include <bits/stdc++.h>

using namespace std;

bool overflowtest = true;
//if true, add/sub/addi; else if false, addu/subu/addiu

// hex string to bin string(32 bits)
string hexToBin(const string& hex) {  
    string binary;  
    unsigned int temp;
    sscanf(hex.c_str(), "%x", &temp);
    while (temp) {
        char c = temp % 2 + '0';
        binary = string(1, c) + binary;
        temp /= 2;
    }
    int len = binary.size();
    binary = string(32 - len, '0') + binary;
    return binary;  
}  

// bin string to dec string(unsigned)
string ubinToDec(const string& bin) { 
    string decimal;  
    bitset<32> bitset(bin);  
    unsigned int temp = static_cast<unsigned int>(bitset.to_ulong());
    decimal = to_string(temp);
    return decimal;  
}

// bin string to dec string(signed)
string binToDec(const string& bin) { 
    int len = bin.size(); 
    string decimal;  
    bitset<32> bitset(bin);  
    int temp = static_cast<int>(bitset.to_ulong());
    if (bin[0] == '1') {
        temp = temp - (2 << (len - 1));
    }
    decimal = to_string(temp);
    return decimal;  
}

// bin string to dec int(signed)
int binToDecInt(const string& bin) { 
    int len = bin.size(); 
    string decimal;  
    bitset<32> bitset(bin);  
    int temp = static_cast<int>(bitset.to_ulong());
    if (bin[0] == '1') {
        temp = temp - (2 << (len - 1));
    }
    return temp;  
}
  
int main() {  
    ifstream inputFile("input.txt");  
    ofstream outputFile("output.txt");  
    string line;  
  
    // get hex codes in line
    vector<string> binaryArray;  
    vector<string> mipsCodes;  
    vector<int> labels;
    string label = "label";
    int labelcnt = 0;
    while (getline(inputFile, line)) {  
        // erase the blank characters at beginning or endding of a line
        line.erase(0, line.find_first_not_of(" \t\n\r\f\v"));  
        line.erase(line.find_last_not_of(" \t\n\r\f\v") + 1);  

        // switch line from hex to bin, then push it in binaryArray
        if (!line.empty()) {  
            // cout << line << "\n";
            string binary = hexToBin(line);  
            binaryArray.push_back(binary);  
        }  
    }  
  
    inputFile.close();  

    // print bin codes(using it to debug)
    for (string whichline : binaryArray) {
        cout << whichline << "\n";
    }

    // core: translate bin codes into MIPS codes
    for (string whichline : binaryArray) {
        string mipsline;
        string OpCode = whichline.substr(0, 6);
        string rs = whichline.substr(6, 5);
        string rt = whichline.substr(11, 5);
        string rd = whichline.substr(16, 5);
        string Funct = whichline.substr(26, 6);
        string imm16 = whichline.substr(16, 16);
        string imm26 = whichline.substr(6, 26);
        if (whichline == "00000000000000000000000000000000") {
            // nop
            mipsline += "nop\n";
        }
        else if (whichline == "01000000000000000000000000011000") {
            // eret
            mipsline += "eret\n";
        }      
        else if (OpCode == "000000") {
            // special
            if (Funct == "100000") {
                // add
                if (overflowtest) {
                    mipsline += "add ";
                }
                else {
                    mipsline += "addu ";
                }
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "100100") {
                // and
                mipsline += "and ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "011010") {
                // div
                mipsline += "div ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "011011") {
                // divu
                mipsline += "divu ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "001000") {
                //jr
                mipsline += "jr ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += "\n";
            }
            else if (Funct == "010000") {
                // mfhi
                mipsline += "mfhi ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += "\n";
            }
            else if (Funct == "010010") {
                // mflo
                mipsline += "mflo ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += "\n";
            }
            else if (Funct == "010001") {
                // mthi
                mipsline += "mthi ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += "\n";
            }
            else if (Funct == "010011") {
                // mtlo
                mipsline += "mtlo ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += "\n";
            }
            else if (Funct == "011000") {
                // mult
                mipsline += "mult ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "011001") {
                // multu
                mipsline += "multu ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "100101") {
                // or
                mipsline += "or ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "101010") {
                // slt
                mipsline += "slt ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "101011") {
                // sltu
                mipsline += "sltu ";
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "100010") {
                // sub
                if (overflowtest) {
                    mipsline += "sub ";
                }
                else {
                    mipsline += "subu ";
                }
                mipsline += "$";
                mipsline += ubinToDec(rd);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += "\n";
            }
            else if (Funct == "001100") {
                // syscall
                mipsline += "syscall\n";
            }
            else {
                // unknown(using it to debug)
                mipsline += "unknown\n";
            }
        }
        else {
            if (OpCode == "001000") {
                // addi
                if (overflowtest) {
                    mipsline += "addi ";
                }
                else {
                    mipsline += "addiu ";
                }
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "\n";
            }
            else if (OpCode == "001100") {
                // andi
                mipsline += "andi ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", ";
                mipsline += ubinToDec(imm16);
                mipsline += "\n";
            }
            else if (OpCode == "000100") {
                // beq(see more in test-design.md to know how it works)
                int nowlabelcnt;
                int wherelabel = mipsCodes.size() + 1;
                wherelabel += binToDecInt(imm16);
                if (labels.size() <= wherelabel) {
                    labels.resize(wherelabel + 1);
                }
                if (!labels[wherelabel]) {
                    labels[wherelabel] = (++labelcnt);
                    nowlabelcnt = labelcnt;
                }
                else {
                    nowlabelcnt = labels[wherelabel];
                }
                mipsline += "beq ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += label;
                mipsline += to_string(nowlabelcnt);
                mipsline += "\n";
            }
            else if (OpCode == "000101") {
                // bne(see more in test-design.md to know how it works)
                int nowlabelcnt;
                int wherelabel = mipsCodes.size() + 1;
                wherelabel += binToDecInt(imm16);
                if (labels.size() <= wherelabel) {
                    labels.resize(wherelabel + 1);
                }
                if (!labels[wherelabel]) {
                    labels[wherelabel] = (++labelcnt);
                    nowlabelcnt = labelcnt;
                }
                else {
                    nowlabelcnt = labels[wherelabel];
                }
                mipsline += "bne ";
                mipsline += "$";
                mipsline += ubinToDec(rs);
                mipsline += ", $";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += label;
                mipsline += to_string(nowlabelcnt);
                mipsline += "\n";
            }
            else if (OpCode == "100000") {
                // lb
                mipsline += "lb ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "100001") {
                // lh
                mipsline += "lh ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "001111") {
                // lui
                mipsline += "lui ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += ubinToDec(imm16);
                mipsline += "\n";
            }
            else if (OpCode == "100011") {
                // lw
                mipsline += "lw ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "000010") {
                //j
                int nowlabelcnt;
                int wherelabel = binToDecInt(imm26) - 3072; // (3072 == (0x3000 >> 2))
                if (labels.size() <= wherelabel) {
                    labels.resize(wherelabel + 1);
                }
                if (!labels[wherelabel]) {
                    labels[wherelabel] = (++labelcnt);
                    nowlabelcnt = labelcnt;
                }
                else {
                    nowlabelcnt = labels[wherelabel];
                }
                mipsline += "j ";
                mipsline += label;
                mipsline += to_string(nowlabelcnt);
                mipsline += "\n";
            }
            else if (OpCode == "000011") {
                //jal
                int nowlabelcnt;
                int wherelabel = binToDecInt(imm26) - 3072; // (3072 == (0x3000 >> 2))
                if (labels.size() <= wherelabel) {
                    labels.resize(wherelabel + 1);
                }
                if (!labels[wherelabel]) {
                    labels[wherelabel] = (++labelcnt);
                    nowlabelcnt = labelcnt;
                }
                else {
                    nowlabelcnt = labels[wherelabel];
                }
                mipsline += "jal ";
                mipsline += label;
                mipsline += to_string(nowlabelcnt);
                mipsline += "\n";
            }
            else if (OpCode == "001101") {
                // ori
                mipsline += "ori ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", $";
                mipsline += ubinToDec(rs);
                mipsline += ", ";
                mipsline += ubinToDec(imm16);
                mipsline += "\n";
            }
            else if (OpCode == "101000") {
                // sb
                mipsline += "sb ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "101001") {
                // sh
                mipsline += "sh ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "101011") {
                // sw
                mipsline += "sw ";
                mipsline += "$";
                mipsline += ubinToDec(rt);
                mipsline += ", ";
                mipsline += binToDec(imm16);
                mipsline += "($";
                mipsline += ubinToDec(rs);
                mipsline += ")\n";
            }
            else if (OpCode == "010000") {
                if (rs == "00000") {
                    // mfc0
                    mipsline += "mfc0 ";
                    mipsline += "$";
                    mipsline += ubinToDec(rt);
                    mipsline += ", $";
                    mipsline += ubinToDec(rd);
                    mipsline += "\n";
                }
                else if (rs == "00100") {
                    // mtc0
                    mipsline += "mtc0 ";
                    mipsline += "$";
                    mipsline += ubinToDec(rt);
                    mipsline += ", $";
                    mipsline += ubinToDec(rd);
                    mipsline += "\n";
                }
                else {
                    // unknown(using it to debug)
                    mipsline += "unknown\n";
                }
            }
            else {
                // unknown(using it to debug)
                mipsline += "unknown\n";
            }
        }
        mipsCodes.push_back(mipsline);
    }
    
    // print codes and labels(see more in test-design.md to know how it works)
    for (int i = 0; i < mipsCodes.size(); i++) {
        if (i < labels.size() && labels[i]) {
            outputFile << label + to_string(labels[i]) + ":\n";
        }
        outputFile << mipsCodes[i];
    }
    for (int i = mipsCodes.size(); i < labels.size(); i++) {
        outputFile << label + to_string(labels[i]) + ":\n";
    }
  
    outputFile.close();  
  
    return 0;  
}