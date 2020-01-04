#if !defined(AFX_FREIGHTEASYNETPPG_H__D32BF949_59E0_4FA1_917A_35D97DB15760__INCLUDED_)
#define AFX_FREIGHTEASYNETPPG_H__D32BF949_59E0_4FA1_917A_35D97DB15760__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// FreightEasyNetPpg.h : Declaration of the CFreightEasyNetPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetPropPage : See FreightEasyNetPpg.cpp.cpp for implementation.

class CFreightEasyNetPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CFreightEasyNetPropPage)
	DECLARE_OLECREATE_EX(CFreightEasyNetPropPage)

// Constructor
public:
	CFreightEasyNetPropPage();

// Dialog Data
	//{{AFX_DATA(CFreightEasyNetPropPage)
	enum { IDD = IDD_PROPPAGE_FREIGHTEASYNET };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CFreightEasyNetPropPage)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FREIGHTEASYNETPPG_H__D32BF949_59E0_4FA1_917A_35D97DB15760__INCLUDED)
