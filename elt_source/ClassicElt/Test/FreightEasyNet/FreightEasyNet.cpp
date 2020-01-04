// FreightEasyNet.cpp : Implementation of CFreightEasyNetApp and DLL registration.

#include "stdafx.h"
#include "cathelp.h"
#include "FreightEasyNet.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


CFreightEasyNetApp NEAR theApp;

const GUID CDECL BASED_CODE _tlid =
		{ 0xc3a6b5de, 0xd6ed, 0x4ad5, { 0xb3, 0x31, 0x9a, 0x9d, 0x30, 0x56, 0xcf, 0xc3 } };
const CATID CATID_SafeForScripting =
		{0x7dd95801,0x9882,0x11cf,{0x9f,0xa9,0x00,0xaa,0x00,0x6c,0x42,0xc4}};
const CATID CATID_SafeForInitializing  =
		{0x7dd95802,0x9882,0x11cf,{0x9f,0xa9,0x00,0xaa,0x00,0x6c,0x42,0xc4}};
const GUID CDECL BASED_CODE _ctlid =
		{ 0x34fd3126, 0x734c, 0x4f94, 0xb0, 0x6, 0x8e, 0x1b, 0x23, 0xe1, 0x49, 0xc8 };


const WORD _wVerMajor = 1;
const WORD _wVerMinor = 0;


////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetApp::InitInstance - DLL initialization

BOOL CFreightEasyNetApp::InitInstance()
{
	BOOL bInit = COleControlModule::InitInstance();

	if (bInit)
	{
		// TODO: Add your own module initialization code here.
	}

	return bInit;
}


////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetApp::ExitInstance - DLL termination

int CFreightEasyNetApp::ExitInstance()
{
	// TODO: Add your own module termination code here.

	return COleControlModule::ExitInstance();
}


/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleRegisterTypeLib(AfxGetInstanceHandle(), _tlid))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(TRUE))
		return ResultFromScode(SELFREG_E_CLASS);

	if (FAILED( CreateComponentCategory(CATID_SafeForScripting, L"Controls that are safely scriptable") ))
        return ResultFromScode(SELFREG_E_CLASS);

    if (FAILED( CreateComponentCategory(CATID_SafeForInitializing, L"Controls safely initializable from persistent data") ))
            return ResultFromScode(SELFREG_E_CLASS);

    if (FAILED( RegisterCLSIDInCategory(_ctlid, CATID_SafeForScripting) ))
            return ResultFromScode(SELFREG_E_CLASS);

    if (FAILED( RegisterCLSIDInCategory(_ctlid, CATID_SafeForInitializing) ))
            return ResultFromScode(SELFREG_E_CLASS);


	return NOERROR;
}


/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleUnregisterTypeLib(_tlid, _wVerMajor, _wVerMinor))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(FALSE))
		return ResultFromScode(SELFREG_E_CLASS);

	return NOERROR;
}
