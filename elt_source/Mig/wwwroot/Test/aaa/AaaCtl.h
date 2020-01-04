#if !defined(AFX_AAACTL_H__613ACF56_7C32_49B0_B07D_FA80612A1761__INCLUDED_)
#define AFX_AAACTL_H__613ACF56_7C32_49B0_B07D_FA80612A1761__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// AaaCtl.h : Declaration of the CAaaCtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl : See AaaCtl.cpp for implementation.

class CAaaCtrl : public COleControl
{
	DECLARE_DYNCREATE(CAaaCtrl)

// Constructor
public:
	CAaaCtrl();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAaaCtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CAaaCtrl();

	DECLARE_OLECREATE_EX(CAaaCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CAaaCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CAaaCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CAaaCtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CAaaCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CAaaCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

// Event maps
	//{{AFX_EVENT(CAaaCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
	//{{AFX_DISP_ID(CAaaCtrl)
		// NOTE: ClassWizard will add and remove enumeration elements here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DISP_ID
	};
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AAACTL_H__613ACF56_7C32_49B0_B07D_FA80612A1761__INCLUDED)
