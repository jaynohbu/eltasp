#pragma once

// ClientTrackCtrl.h : Declaration of the CClientTrackCtrl ActiveX Control class.


// CClientTrackCtrl : See ClientTrackCtrl.cpp for implementation.

class CClientTrackCtrl : public COleControl
{
	DECLARE_DYNCREATE(CClientTrackCtrl)

// Constructor
public:
	CClientTrackCtrl();

// Overrides
public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();

// Implementation
protected:
	~CClientTrackCtrl();

	DECLARE_OLECREATE_EX(CClientTrackCtrl)    // Class factory and guid
	DECLARE_OLETYPELIB(CClientTrackCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CClientTrackCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CClientTrackCtrl)		// Type name and misc status

// Message maps
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Event maps
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
        dispidGetMacAddr = 2L,
        dispidGetIPAddr = 1L
    };
protected:
    BSTR GetIPAddr(void);
    BSTR GetMacAddr(void);
};

