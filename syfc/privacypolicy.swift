//
//  privacypolicy.swift
//  newsyfc
//
//  Created by Admin on 18/5/22.
//

import Foundation
import SwiftUI

struct privacypolicy: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Group{
                Text("SINGAPORE YOUTH FLYING CLUB DATA PROTECTION POLICY")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nWe, at SINGAPORE YOUTH FLYING CLUB (‘SYFC”), respect your privacy and take our responsibilities under the Personal Data Protection Act 2012 (the \"PDPA\") seriously. \n\nThis Data Protection Policy is established to assist you in understanding how we collect, use and/or disclose the personal data you have provided us.")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group {
                Text("Definition of Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\n\"Personal Data\" as defined under the PDPA refers to \"data, whether true or not, about an individual who can be identified from that data, or from that data and other information to which an organisation has or is likely to have access\". Common examples of personal data could include names of individuals, and their unique identification numbers, personal contact information, and personally identifiable photographs and video images.")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Collection of Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nIn general, before we collect any personal data from you, we will notify you of the purpose(s) for which your personal data may be collected, used and/or disclosed for the intended purpose(s). We will first obtain your consent before we collect your personal data, unless there are exceptions to consent under the PDPA. \n\nYou may withdraw your consent at any time by giving us reasonable advance notice in writing. \n\nWe collect your personal data through the following means:\n\n   (I)   when you submit an application form to us\n\n   (II)   when you interact with us through the telephone, letters, face-to-face meetings or emails\n\n   (III)   when you use some of our services or resources\n\n   (IV)   when you request that we contact you\n\n   (V)   when you submit your personal data to us for any other reason(s) related to the services we provide\n\nWe will take reasonable steps to ensure that the personal data we collect about you is accurate, complete and up-to-date.")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Purposes of Using Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nWe use the personal data collected from you for the following purposes:\n\n   (I)   To verify your identity for security or other administrative purpose(s)\n\n   (II)   To evaluate your application eligibility or process your application\n\n   (III)   To facilitate your participation in the events organised by us\n\n   (IV)   To respond to your queries or feedback, or communicate with you\n\n   (V)   To publish event videos, photographs, articles, membership and activity updates, publicity materials and/or other features on our website, in our newsletters, on our social media platforms or other hardcopies\n\n   (VI)   To respond to requests for information from government or public agencies, ministries, statutory boards or other similar authorities or non-government agencies authorised to carry out specific Government services or duties")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Disclosure of Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nWe respect your privacy and will take reasonable steps to protect your personal data against any unauthorised disclosure to recipient(s) without a valid business or legal purpose.\n\nHowever, please note that we may disclose your personal data to third parties without first obtaining your consent in certain situations such as the following:\n\n   (I)   when the disclosure is required for compliance with the laws of Singapore\n\n   (II)   when the disclosure is necessary to respond to an emergency that threatens the life, health or safety of the member\n\n   (III)   when the disclosure is necessary for any investigation or legal proceedings")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Protection and Retention of Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nWe have implemented appropriate information security measures to protect the personal data we hold about you against loss; misuse; destruction; unauthorised alteration/modification, access, disclosure or similar risks.\n\nWe will not hold or retain your personal data when it is no longer necessary for any business or legal purpose(s). We will dispose of or destroy personal data that is no longer needed in a secure manner. This applies to both paper documents and electronic data.")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Access and Correction of Personal Data")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nYou may write in to us to find out how we have been using or disclosing your personal data over the past one year. If you find that the personal data we hold about you is inaccurate, incomplete, misleading or not up-to-date, you may ask us to correct the data.")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            Group{
                Text("Contact Us")
                    .font(.system(size: 24))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                Text("\nIf you have any question or feedback in relation to how your personal data is being handled by us, please contact our Data Protection Officer at dpo@syfc.sg")
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
            }
            
        }
        .padding()
    }
}
