//
//  CommentDetails.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import SwiftUI

struct CommentDetails: View {
    let comment: CommentData
    
    var body: some View {
        if let username = comment.username,
           let rating = comment.rating,
           let body = comment.body,
           let time = comment.created,
           let link = comment.permalink {
            ScrollView{
                VStack (spacing: 4) {
                    VStack (alignment:.leading) {
                        HStack {
                            Text("/u /\(username)")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(time)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .padding(8)
                                .background(Color(.lightGray),
                                            in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                        
                        ScrollView{
                            VStack {
                                Text(body)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .font(.callout)
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(.systemGray2), lineWidth: 1)
                        )
                        
                        HStack() {
                            Text("Rating: ")
                            Label("\(rating)", systemImage: "arrow.up.arrow.down")
                                .foregroundColor(rating > 0 ? Color(.systemGreen): Color(.systemRed))
                        }
                        .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.systemGray))
                    .cornerRadius(15)
                    
                    ShareLink(item: link){
                        Label("Share", systemImage: "square.and.arrow.up")
                            .foregroundColor(Color(.black))
                    }
                    .padding(8)
                    .background(Color(.systemYellow))
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .padding(4)
            }
        }
    }
}

struct CommentDetails_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetails(comment: CommentData.testComment)
    }
}
