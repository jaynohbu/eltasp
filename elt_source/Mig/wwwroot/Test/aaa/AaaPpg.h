#if !defined(AFX_AAAPPG_H__05D23A97_EED7_4366_A721_96232B44D8B7__INCLUDED_)
#define AFX_AAAPPG_H__05D23A97_EED7_4366_A721_96232B44D8B7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// AaaPpg.h : Declaration of the CAaaPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CAaaPropPage : See AaaPpg.cpp.cpp for implementation.

class CAaaPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CAaaPropPage)
	DECLARE_OLECREATE_EX(CAaaPropPage)

// Constructor
public:
	CAaaPropPage();

// Dialog Data
	//{{AFX_DATA(CAaaPropPage)
	enum { IDD = IDD_PROPPAGE_AAA };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CAaaPropPage)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AAAPPG_H__05D23A97_EED7_4366_A721_96232B44D8B7__INCLUDED)
