using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ELT.COMMON
{
   public class EmailConstants
    {
       public const string PATH_TEMPLATE_AGENT_PRE_ALERT = "~/EmailTemplates/AgentPreAlert.htm";
       public const string PATH_TEMPLATE_SHIPPING_NOTICE = "~/EmailTemplates/ShippingNotice.htm";
     
       public const string SUBJECT_AGENT_PRE_ALERT = "Agent Pre Alert";
       public const string SUBJECT_SHIPPING_NOTICE = "Shipping Notice";
       public const string REGEX_MAIL_MUTIPLE_EMAILS=@"^((?:(?:[a-zA-Z0-9_\-\.]+)@(?:(?:\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(?:(?:‌​[a-zA-Z0-9\-]+\.)+))(?:[a-zA-Z]{2,4}|[0-9]{1,3})(?:\]?)(?:\s*;\s*|\s*$))*)$";

    }


}
