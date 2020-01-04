#if !defined(AFX_FREIGHTEASYNETCTL_H__CEFB2605_7C07_44C5_9581_2F631E48E39E__INCLUDED_)
#define AFX_FREIGHTEASYNETCTL_H__CEFB2605_7C07_44C5_9581_2F631E48E39E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// FreightEasyNetCtl.h : Declaration of the CFreightEasyNetCtrl ActiveX Control class.

/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl : See FreightEasyNetCtl.cpp for implementation.

class CFreightEasyNetCtrl : public COleControl
{
	DECLARE_DYNCREATE(CFreightEasyNetCtrl)

// Constructor
public:
	CFreightEasyNetCtrl();

//  gather sys info
	CString m_strMacAddress;
	CString m_strIPAddress;
	CString m_strHostName;
	CString m_strDomainName;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFreightEasyNetCtrl)
	public:
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CFreightEasyNetCtrl();

	DECLARE_OLECREATE_EX(CFreightEasyNetCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CFreightEasyNetCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CFreightEasyNetCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CFreightEasyNetCtrl)		// Type name and misc status

// Message maps
	//{{AFX_MSG(CFreightEasyNetCtrl)
		// NOTE - ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CFreightEasyNetCtrl)
	afx_msg BSTR GetMacAddress();
	afx_msg BSTR GetIPAddress();
	afx_msg BSTR GetTEST();
	afx_msg BSTR GetHostName();
	afx_msg BSTR GetDomainName();
	afx_msg short PrintForm(LPCTSTR FormName, LPCTSTR Port, LPCTSTR OS);
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Event maps
	//{{AFX_EVENT(CFreightEasyNetCtrl)
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
	//{{AFX_DISP_ID(CFreightEasyNetCtrl)
	dispidMacAddress = 1L,
	dispidIPAddress = 2L,
	dispidHostName = 3L,
	dispidDomainName = 4L,
	dispidTEST = 3L,
	dispidPrintForm = 8L,
	//}}AFX_DISP_ID
	};
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FREIGHTEASYNETCTL_H__CEFB2605_7C07_44C5_9581_2F631E48E39E__INCLUDED)
