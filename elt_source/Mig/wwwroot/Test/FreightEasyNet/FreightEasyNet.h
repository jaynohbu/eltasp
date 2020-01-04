#if !defined(AFX_FREIGHTEASYNET_H__E097D2D7_02B3_4829_8F25_770F99F252C6__INCLUDED_)
#define AFX_FREIGHTEASYNET_H__E097D2D7_02B3_4829_8F25_770F99F252C6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// FreightEasyNet.h : main header file for FREIGHTEASYNET.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetApp : See FreightEasyNet.cpp for implementation.

class CFreightEasyNetApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FREIGHTEASYNET_H__E097D2D7_02B3_4829_8F25_770F99F252C6__INCLUDED)
