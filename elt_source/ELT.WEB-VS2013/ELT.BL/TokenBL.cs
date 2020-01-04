using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.DA;
using ELT.CDT;
namespace ELT.BL
{
    public class TokenBL
    {
       

        public void CreateToken(ref string Token, TokenType TokenType, string RecipientEmail, bool NoStart, int Period)
        {
            TokenDA da = new TokenDA();
            da.CreateToken(ref Token, TokenType, RecipientEmail, NoStart, Period);
        }

        public ELTToken GetToken(string Token)
        {
            TokenDA da = new TokenDA();
           return da.GetToken(Token);
        }
    }
}
