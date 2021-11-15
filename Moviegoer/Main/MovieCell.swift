//
//  FilmCell.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
class MovieCell: UITableViewCell {
    
    static var cellId = "movieCell"
    private var viewModel = MovieViewModel()
    
    private var img: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        return view
    }()
    
     private var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
     }()
    
    private var rating: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private var ratingImage: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        return view
    }()
    
    private var date: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var synopsis: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        title.text = nil
        rating.text = nil
        synopsis.text = nil
        date.text = nil
        img.image = nil
    }
    
    func setCellWithValuesOf(_ movie: Movie) {
        title.text = movie.title
        guard let rate = movie.rating else {return}
        rating.text = String(rate)
        synopsis.text = movie.synopsis
        date.text = DateFormatter().convertDateFormater(movie.year)
        ratingImage.image = Images.ratedStar
        
        viewModel.fetchPoster(movie: movie){ [weak self] (data) in
            guard let fetchedData = data else {
                DispatchQueue.main.async {
                    self?.img.image = Images.movie
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: fetchedData) {
                    self?.img.image = image
                }
                else {print ("Error of UIImage creation")}
            }
        }
    }
    
    private func setupConstraints() {
        img.snp.makeConstraints { (make) in
            make.height.equalTo(170)
            make.top.left.equalTo(15)
            make.width.equalTo(img.snp.height).multipliedBy(1.0 / 1.5)
        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(20)
            make.top.equalTo(img.snp.top)
            make.height.lessThanOrEqualTo(50).priority(.low)
            make.right.equalTo(-15)
        }
        date.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(20)
            make.top.equalTo(title.snp.bottom).offset(5).priority(.required)
            make.right.equalTo(-15)
        }
        synopsis.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(20)
            make.right.equalTo(-15)
            make.top.equalTo(date.snp.bottom).offset(10)
            make.bottom.equalTo(ratingImage.snp.top).offset(-5)
        }
        rating.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        ratingImage.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.right.equalTo(rating.snp.left).offset(-5)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(ratingImage.snp.height).multipliedBy(1.0 / 1.0)
        }
    }
    
    private func setupSubviews() {
        contentView.addSubview(img)
        contentView.addSubview(title)
        contentView.addSubview(date)
        contentView.addSubview(synopsis)
        contentView.addSubview(rating)
        contentView.addSubview(ratingImage)
    }
}
