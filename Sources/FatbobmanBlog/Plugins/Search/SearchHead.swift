//
//  File.swift
//
//
//  Created by Yang Xu on 2021/1/28.
//
// 目前仅用于演示.
import Foundation
import Ink
import Plot
import Publish
import Sweep

public extension Node where Context == HTML.DocumentContext {
    static func searchHead<T: Website>(
        for location: Location,
        on site: T,
        titleSeparator: String = " | ",
        stylesheetPaths: [Path] = ["/styles.css"],
        rssFeedPath: Path? = .defaultForRSSFeed,
        rssFeedTitle: String? = nil
    ) -> Node {
        var title = location.title

        if title.isEmpty {
            title = site.name
        } else {
            title.append(titleSeparator + site.name)
        }

        var description = location.description

        if description.isEmpty { description = site.description }

        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .meta(.name("twitter:site"), .content("@fatbobman")),
            .meta(.name("twitter:creator"), .content("@fatbobman")),
            .meta(.name("referrer"), .content("no-referrer")),
            .forEach(stylesheetPaths) { .stylesheet($0) },
            .viewport(.accordingToDevice),
            .unwrap(site.favicon) { .favicon($0) },
            .unwrap(
                rssFeedPath,
                { path in let title = rssFeedTitle ?? "Subscribe to \(site.name)"
                    return .rssFeedLink(path.absoluteString, title: title)
                }
            ),
            .unwrap(
                location.imagePath ?? site.imagePath,
                { path in
                    let url = site.url(for: path)
                    return .socialImageLink(url)
                }
            ),
            .script(.src("//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"))
        )
    }
}
