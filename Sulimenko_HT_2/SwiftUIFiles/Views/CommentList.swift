//
//  CommentList.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import SwiftUI

struct CommentList: View {
    @EnvironmentObject var viewModel: CommentStorage
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.comments) { element in
                        NavigationLink {
                            CommentDetails(comment: element)
                        } label: {
                            CommentCell(comment: element)
                        }
                        .foregroundColor(.black)
                    }
                    
                    Color.clear
                        .onAppear {
                            viewModel.loadMoreComments()
                        }
                }
            }
            .navigationTitle("Comments")
        }
    }
}

struct CommentList_Previews: PreviewProvider {
    static var previews: some View {
        CommentList()
            .environmentObject(
                CommentStorage(subreddit: "books", postID: "126fy5e")
            )
    }
}
