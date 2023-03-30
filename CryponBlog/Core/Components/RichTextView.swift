//
//  RichTextView.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 23.05.2022
//

import SwiftUI
import RichTextRenderer
import Contentful


struct ExampleViewProvider: ResourceLinkBlockViewProviding {
    func view(for resource: Contentful.Link, context: [CodingUserInfoKey: Any]) -> ResourceLinkBlockViewRepresentable? {
        switch resource {
            //         case .entryDecodable(let _):
            //             if let car = entryDecodable as? Car {
            //                 return CarView(car: car)
            //             }
            //
            //             return nil
            //
            //         case .entry(let entry):
            //             return nil
            
        case .asset(let asset):
            guard asset.file?.details?.imageInfo != nil else { return nil }
            
            let imageView = ResourceLinkBlockImageView(asset: asset)
            
            imageView.backgroundColor = .gray
            imageView.setImageToNaturalHeight()
            return imageView
            
        default:
            return nil
        }
    }
}

struct RichTextView: UIViewControllerRepresentable {
    typealias UIViewControllerType = BlogPostUIViewController
    
    let content: RichTextDocument
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<RichTextView>) -> RichTextView.UIViewControllerType {
        return BlogPostUIViewController(content: content)
    }
    
    func updateUIViewController(_ uiViewController: RichTextView.UIViewControllerType, context: UIViewControllerRepresentableContext<RichTextView>) {
    }
}


class BlogPostUIViewController: RichTextViewController {
    private let content: RichTextDocument
    private var firstAppear = true
    
    init(content: RichTextDocument) {
        var configuration = DefaultRendererConfiguration()
        configuration.resourceLinkBlockViewProvider = ExampleViewProvider()
        
        let renderer = RichTextDocumentRenderer(configuration: configuration)
        
        self.content = content
        
        super.init(renderer: renderer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppear {
            firstAppear = false
            
            self.richTextDocument = content
            
            DispatchQueue.main.async {
                for view in self.view.subviews {
                    if let textView = view as? UITextView {
                        textView.isScrollEnabled = false
                        return
                    }
                }
            }
        }
    }
}
