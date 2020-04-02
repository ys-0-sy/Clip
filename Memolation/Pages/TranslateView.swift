//
//  TranslateView.swift
//  Memolation
//
//  Created by saito on 2020/03/27.
//  Copyright © 2020 ys-0-sy. All rights reserved.
//

import SwiftUI
import Combine

struct TranslateView: View {
  @State private var showAfterView: Bool = false
  @ObservedObject private var myData = UserData()
  @State private var detectedLanguage: String = "Auto Detect"
  @State var surpportedLanguages = TranslationManager.shared.supportedLanguages
  @State private var languageSelection = TranslationLanguage(code: "ja", name: "Japanese")
  @State private var translatedText: String = "Enter Text"
 
  var body: some View {
    NavigationView {
      ScrollView {
      VStack {
        Button(action: {TranslationManager.shared.detectLanguage(forText: self.myData.text, completion: {(language) in
          if let language = language {
            self.detectedLanguage = language
            for lang in TranslationManager.shared.supportedLanguages {
              if lang.code == language {
                self.detectedLanguage = lang.name ?? language
              }
            }
            
          } else {
            self.detectedLanguage = "Oops! It seems that something went wrong and language cannot be detected."
          }
        })}) {
          Text(detectedLanguage)
        }
        MultilineTextField(text: $myData.text)
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 5)
        )
        HStack {
          NavigationLink(destination:
            VStack {
              Button(action: {self.showAfterView = false}){
                  Text("Back")
              }
              ChooseLanguages(showAfterView: $showAfterView, languageSelection: $languageSelection)
            }
          .navigationBarBackButtonHidden(true),isActive: $showAfterView) {
              Button(action: {self.showAfterView = true}){
                  Text("Target Laguage")
              }
          }
          Text(self.languageSelection.name!)
        }
        Card(text:  $translatedText)
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
        
        Button(action: {
          TranslationManager.shared.targetLanguageCode = self.languageSelection.code!
          TranslationManager.shared.textToTranslate = self.myData.text
          TranslationManager.shared.translate(completion: {(returnString) in
            if let returnString = returnString  {
              self.translatedText = returnString
            } else {
              self.translatedText = "translation error"
            }
           
          })
        }) {
          Text("Translate")
        }
        Spacer()
        Card(text: $myData.text)
          .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
      }.onTapGesture {
        self.endEditing()
      }
    }
    }
  }
  private func endEditing() {
      UIApplication.shared.endEditing()
  }
  
}


struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
    }
}
