//
//  CommentCell.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import SwiftUI

struct CommentCell: View {
    let comment: CommentData
    
    var body: some View {
        if let username = comment.username,
           let rating = comment.rating,
           let body = comment.body,
           let time = comment.created {
            VStack (alignment: .leading, spacing: 16){
                HStack {
                    Group {
                        Text("/u")
                        Text("/\(username)")
                    }
                    .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(time)
                        .fontWeight(.medium)
                        .padding(8)
                        .background(Color(.lightGray),
                                    in: RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                }
                
                Text(body)
                    .frame(maxHeight: 120)
                    .multilineTextAlignment(.leading)
                
                Label("\(rating)", systemImage: "arrow.up.arrow.down")
                    .fontWeight(.semibold)
                    .foregroundColor(rating > 0 ? Color(.systemGreen): Color(.systemRed))
            }
            .padding(8)
            .background(Color(.systemGray))
        }
    }
}

struct CommentCell_Previews: PreviewProvider {
    static var previews: some View {
        CommentCell(comment: CommentData.testComment)
    }
}
