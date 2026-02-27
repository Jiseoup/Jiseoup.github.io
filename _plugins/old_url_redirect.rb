# _plugins/old_url_redirect.rb
#
# slug가 설정된 포스트에 대해 파일명 기반의 이전 URL(한글, URL인코딩)을
# 새 slug URL로 자동 리다이렉트하는 페이지를 생성합니다.
#
# 포스트 front matter에 redirect_from을 직접 작성할 필요가 없습니다.

module Jekyll
  class OldUrlRedirectGenerator < Generator
    safe true
    priority :low

    def generate(site)
      base_url = site.config['url'] || ''

      site.posts.docs.each do |post|
        slug = post.data['slug']
        next unless slug

        filename_stem = File.basename(post.path, File.extname(post.path))
        title_part = filename_stem.sub(/\A\d{4}-\d{2}-\d{2}-/, '')
        old_title = title_part.tr(' ', '-')

        new_url     = post.url
        full_new_url = "#{base_url}#{new_url}"

        korean_path  = "/posts/#{old_title}/"
        encoded_path = "/posts/#{encode_non_ascii(old_title)}/"

        [korean_path, encoded_path].uniq.each do |from_path|
          next if from_path == new_url
          site.pages << build_redirect_page(site, from_path, full_new_url)
        end
      end
    end

    private

    def encode_non_ascii(str)
      str.chars.map do |c|
        if c.ord < 128
          c
        else
          c.encode('UTF-8').bytes.map { |b| '%%%02X' % b }.join
        end
      end.join
    end

    def build_redirect_page(site, from_path, to_url)
      html = <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta http-equiv="refresh" content="0; url=#{to_url}">
          <link rel="canonical" href="#{to_url}">
          <script>window.location.replace("#{to_url}");</script>
        </head>
        <body>
          <p>Redirecting... <a href="#{to_url}">Click here if not redirected.</a></p>
        </body>
        </html>
      HTML

      page = PageWithoutAFile.new(site, site.source, from_path, 'index.html')
      page.content = html
      page.data['layout'] = nil
      page.data['sitemap'] = false
      page
    end
  end
end
