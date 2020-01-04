// ClientTrack.cpp : Implementation of CClientTrackApp and DLL registration.

#include "stdafx.h"
#include "ClientTrack.h"
#include "comcat.h"
#include "strsafe.h"
#include "objsafe.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


CClientTrackApp theApp;

const GUID CDECL BASED_CODE _tlid =
    { 0x6FD5081B, 0x30BB, 0x47C2, { 0x8D, 0x21, 0x58, 0x6C, 0xE3, 0x23, 0x29, 0x1C } };
const WORD _wVerMajor = 1;
const WORD _wVerMinor = 0;



// CClientTrackApp::InitInstance - DLL initialization

BOOL CClientTrackApp::InitInstance()
{
	BOOL bInit = COleControlModule::InitInstance();

	if (bInit)
	{
		// TODO: Add your own module initialization code here.
	}

	return bInit;
}

// CClientTrackApp::ExitInstance - DLL termination

int CClientTrackApp::ExitInstance()
{
	// TODO: Add your own module termination code here.

	return COleControlModule::ExitInstance();
}

const CATID CLSID_SafeItem =
    { 0x794834bd, 0x2c77, 0x4d7e,{ 0x91, 0x89, 0x68, 0xaa, 0x99, 0xdc, 0x42, 0x6b} };
 
// HRESULT CreateComponentCategory - Used to register ActiveX control as safe
 
HRESULT CreateComponentCategory(CATID catid, WCHAR *catDescription)
{
    ICatRegister *pcr = NULL ;
    HRESULT hr = S_OK ;
 
    hr = CoCreateInstance(CLSID_StdComponentCategoriesMgr, 
            NULL, CLSCTX_INPROC_SERVER, IID_ICatRegister, (void**)&pcr);
    if (FAILED(hr))
        return hr;
 
    // Make sure the HKCR\Component Categories\{..catid...}
    // key is registered.
    CATEGORYINFO catinfo;
    catinfo.catid = catid;
    catinfo.lcid = 0x0409 ; // english
    size_t len;
    // Make sure the provided description is not too long.
    // Only copy the first 127 characters if it is.
    // The second parameter of StringCchLength is the maximum
    // number of characters that may be read into catDescription.
    // There must be room for a NULL-terminator. The third parameter
    // contains the number of characters excluding the NULL-terminator.
    hr = StringCchLength(catDescription, STRSAFE_MAX_CCH, &len);
    if (SUCCEEDED(hr))
        {
        if (len>127)
          {
            len = 127;
          }
        }   
    else
        {
          // TODO: Write an error handler;
        }
    // The second parameter of StringCchCopy is 128 because you need 
    // room for a NULL-terminator.
    hr = StringCchCopy(catinfo.szDescription, len + 1, catDescription);
    // Make sure the description is null terminated.
    catinfo.szDescription[len + 1] = '\0';
 
    hr = pcr->RegisterCategories(1, &catinfo);
    pcr->Release();
 
    return hr;
}
 
// HRESULT RegisterCLSIDInCategory -
//      Register your component categories information
 
HRESULT RegisterCLSIDInCategory(REFCLSID clsid, CATID catid)
{
// Register your component categories information.
    ICatRegister *pcr = NULL ;
    HRESULT hr = S_OK ;
    hr = CoCreateInstance(CLSID_StdComponentCategoriesMgr, 
                NULL, CLSCTX_INPROC_SERVER, IID_ICatRegister, (void**)&pcr);
    if (SUCCEEDED(hr))
    {
       // Register this category as being "implemented" by the class.
       CATID rgcatid[1] ;
       rgcatid[0] = catid;
       hr = pcr->RegisterClassImplCategories(clsid, 1, rgcatid);
    }
 
    if (pcr != NULL)
        pcr->Release();
            
    return hr;
}
 
// HRESULT UnRegisterCLSIDInCategory - Remove entries from the registry
 
HRESULT UnRegisterCLSIDInCategory(REFCLSID clsid, CATID catid)
{
    ICatRegister *pcr = NULL ;
    HRESULT hr = S_OK ;
 
    hr = CoCreateInstance(CLSID_StdComponentCategoriesMgr, 
            NULL, CLSCTX_INPROC_SERVER, IID_ICatRegister, (void**)&pcr);
    if (SUCCEEDED(hr))
    {
       // Unregister this category as being "implemented" by the class.
       CATID rgcatid[1] ;
       rgcatid[0] = catid;
       hr = pcr->UnRegisterClassImplCategories(clsid, 1, rgcatid);
    }
 
    if (pcr != NULL)
        pcr->Release();
 
    return hr;
}

// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
    HRESULT hr;    // HResult used by Safety Functions
 
    AFX_MANAGE_STATE(_afxModuleAddrThis);
 
    if (!AfxOleRegisterTypeLib(AfxGetInstanceHandle(), _tlid))
      return ResultFromScode(SELFREG_E_TYPELIB);
 
    if (!COleObjectFactoryEx::UpdateRegistryAll(TRUE))
      return ResultFromScode(SELFREG_E_CLASS);
 
    // Mark the control as safe for initializing.
                                             
    hr = CreateComponentCategory(CATID_SafeForInitializing, 
         L"Controls safely initializable from persistent data!");
    if (FAILED(hr))
      return hr;
 
    hr = RegisterCLSIDInCategory(CLSID_SafeItem, 
         CATID_SafeForInitializing);
    if (FAILED(hr))
        return hr;
 
    // Mark the control as safe for scripting.
 
    hr = CreateComponentCategory(CATID_SafeForScripting, 
                                 L"Controls safely  scriptable!");
    if (FAILED(hr))
        return hr;
 
    hr = RegisterCLSIDInCategory(CLSID_SafeItem, 
                        CATID_SafeForScripting);
    if (FAILED(hr))
        return hr;
 
    return NOERROR;
}



// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
    HRESULT hr;    // HResult used by Safety Functions
 
    AFX_MANAGE_STATE(_afxModuleAddrThis);
 
    if (!AfxOleUnregisterTypeLib(_tlid, _wVerMajor, _wVerMinor))
      return ResultFromScode(SELFREG_E_TYPELIB);
 
    if (!COleObjectFactoryEx::UpdateRegistryAll(FALSE))
      return ResultFromScode(SELFREG_E_CLASS);
 
    // Remove entries from the registry.
 
    hr=UnRegisterCLSIDInCategory(CLSID_SafeItem, 
                     CATID_SafeForInitializing);
    if (FAILED(hr))
      return hr;
 
    hr=UnRegisterCLSIDInCategory(CLSID_SafeItem, 
                        CATID_SafeForScripting);
    if (FAILED(hr))
      return hr;
 
    return NOERROR;
}