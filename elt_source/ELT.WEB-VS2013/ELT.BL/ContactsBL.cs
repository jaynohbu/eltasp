using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ELT.DA;
using ELT.CDT;
namespace ELT.BL
{
    public class ContactsBL
    {
        public List<Contact> GetAllContacts(string account_email)
        {
            ContactsDA da = new ContactsDA();
            return da.GetAllContacts(account_email);
        }
        public List<ContactCity> GetCities(string country)
        {
            ContactsDA da = new ContactsDA();
            return da.GetCities(country);
        }
        public List<ContactCountry> GetCountries()
        {
            ContactsDA da = new ContactsDA();
            return da.GetCountries();
        }

        public void AddContact(string name, string email, string address, string country, string city, string phone, string photoUrl)
        {
            ContactsDA da = new ContactsDA();
             da.AddContact( name,  email,  address,  country,  city,  phone,  photoUrl);            
        }
        public void UpdateContact(int id, string name, string email, string address, string country, string city, string phone, string photoUrl)
        {

            ContactsDA da = new ContactsDA();
             da.UpdateContact( id,  name,  email,  address,  country,  city,  phone,  photoUrl);
        }
        public void DeleteContact(int id)
        {
            ContactsDA da = new ContactsDA();
             da.DeleteContact(id);
        }       
    }
}
