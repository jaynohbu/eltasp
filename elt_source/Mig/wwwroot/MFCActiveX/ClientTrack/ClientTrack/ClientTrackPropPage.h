#pragma once

// ClientTrackPropPage.h : Declaration of the CClientTrackPropPage property page class.


// CClientTrackPropPage : See ClientTrackPropPage.cpp for implementation.

class CClientTrackPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CClientTrackPropPage)
	DECLARE_OLECREATE_EX(CClientTrackPropPage)

// Constructor
public:
	CClientTrackPropPage();

// Dialog Data
	enum { IDD = IDD_PROPPAGE_CLIENTTRACK };

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	DECLARE_MESSAGE_MAP()
};

