//
//  CommentListView.swift
//  V2exOS
//
//  Created by isaced on 2022/7/31.
//

import SwiftUI
import V2exAPI
import MarkdownUI
import Kingfisher

struct CommentListView: View {
    
    @EnvironmentObject private var currentUser: CurrentUserStore
    @EnvironmentObject private var settingsConfig: SettingsConfig
    
    var commentCount: Int?
    var commentList: [V2Comment]?
    
    var body: some View {
        Label("\(commentCount ?? 0) 条回复", systemImage: "bubble.middle.bottom.fill")
        
        if let commentList {
            ForEach(0..<commentList.count, id: \.self) { index in
                let comment = commentList[index]
                
                Divider()
                
                HStack(alignment: .top) {
                    if let avatarUrl = comment.member.avatarLarge {
                        KFImage.url(URL(string: avatarUrl))
                            .resizable()
                            .fade(duration: 0.25)
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .mask(RoundedRectangle(cornerRadius: 4))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            if let username = comment.member.username {
                                UserName(username)
                            }
                            
                            if let created = comment.created {
                                Text(Date(timeIntervalSince1970: TimeInterval(created)).fromNow())
                            }
                            
                            Spacer()
                            
                            Text("#\(index)")
                        }
                        .foregroundColor(Color(NSColor.tertiaryLabelColor))
                        
                        Markdown(
                            comment.content
                                .replacingOccurrences(
                                    of: #"https?.*"#,
                                    with: "[$0]($0)",
                                    options: .regularExpression,
                                    range: nil
                                )
                                .replacingOccurrences(
                                    of: #"@(\w+)"#,
                                    with: "[$0](https://www.v2ex.com/member/$1)",
                                    options: .regularExpression,
                                    range: nil
                                )
                        )
                        .markdownStyle(MarkdownStyle(font: .system(size: settingsConfig.fontSize)))
                        .font(.body)
                    }
                }
            }
        }
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        let commentList = [
            PreviewData.comment,
            PreviewData.comment,
            PreviewData.comment
        ]
        CommentListView(commentList: commentList)
            .previewLayout(.fixed(width: 400, height: 200))
    }
}

