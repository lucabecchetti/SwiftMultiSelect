//
//  ContactsLibrary.swift
//  frind
//
//  Created by Spike on 26/11/15.
//  Copyright © 2015 brokenice. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

public class ContactsLibrary{
    
    //Puntatore alla rubrica
    public static var contactStore = CNContactStore()
  
    public var notifiedSend: Bool = false

    class func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            print("\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings.")
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    public class func getContacts(_ keys:[CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactViewController.descriptorForRequiredKeys()],completionHandler: @escaping (_ success:Bool, _ contacts: [SwiftMultiSelectItem]?) -> Void){
        
        self.requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                
                var contactsArray = [SwiftMultiSelectItem]()
                
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: self.allowedContactKeys())
                
                do {
                    var row = 0
                    try self.contactStore.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        //Ordering contacts based on alphabets in firstname
                        
                        var username    = "\(contact.givenName) \(contact.familyName)"
                        var companyName = contact.organizationName
                        
                        if username.trimmingCharacters(in: .whitespacesAndNewlines) == "" && companyName != ""{
                            username        = companyName
                            companyName     = ""
                        }
                        
                        let item_contact = SwiftMultiSelectItem(row: row, title: username, description: companyName, image: nil, imageURL: nil, color: nil, userInfo: contact)
                        contactsArray.append(item_contact)
                        
                        row += 1
                        
                    })
                    completionHandler(true, contactsArray)
                }
                    //Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch let error as NSError {
                    
                    print(error.localizedDescription)
                }
                
            }else{
                completionHandler(false, nil)
            }
        }
    }
    
    class func allowedContactKeys() -> [CNKeyDescriptor]{
        
        return [
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactNameSuffixKey as CNKeyDescriptor,
            //CNContactNicknameKey,
            //CNContactPhoneticGivenNameKey,
            //CNContactPhoneticMiddleNameKey,
            //CNContactPhoneticFamilyNameKey,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            //CNContactDepartmentNameKey,
            //CNContactJobTitleKey,
            //CNContactBirthdayKey,
            //CNContactNonGregorianBirthdayKey,
            //CNContactNoteKey,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            //CNContactTypeKey,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            //CNContactPostalAddressesKey,
            CNContactDatesKey as CNKeyDescriptor,
            //CNContactUrlAddressesKey,
            //CNContactRelationsKey,
            //CNContactSocialProfilesKey,
            //CNContactInstantMessageAddressesKey
        ]
        
    }
    
    class func getByIdentifier(_ identifier:String,keys:[CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactViewController.descriptorForRequiredKeys()]) -> CNContact?{
        
        do {
            let refetchedContact = try self.contactStore.unifiedContact(withIdentifier: identifier, keysToFetch: keys)
            return refetchedContact
        } catch {
            return nil
        }
        
    }
    
    class func getImageByIdentifier(_ identifier:String) -> Data?{
        
        let cont:CNContact? = self.getByIdentifier(identifier, keys: [CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor])
        if(cont != nil && cont!.imageDataAvailable && cont!.imageData!.count > 0){
            return cont!.imageData
        }
        
        return nil
        
    }
    
}

