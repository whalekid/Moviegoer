//
//  DetailView.swift
//  Moviegoer
//
//  Created by кит on 03/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    private var viewModel = MovieViewModel()
    
    private var img: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        return view
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
         return label
     }()
    
    private var rating: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.font = UIFont.boldSystemFont(ofSize: 30.0)
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
    
    func initialize(_ movie: Movie) {
        setupUI()
        setupConstraints()
        updateUI(movie)
    }
    
    private func updateUI(_ movie: Movie) {
        name.text = movie.title
        guard let rate = movie.rating else {return}
        rating.text = String(rate)
        synopsis.text = movie.synopsis
        date.text = DateFormatter().convertDateFormater(movie.year)
        ratingImage.image = Images.ratedStar
        
        viewModel.fetchPoster(movie: movie){ [weak self] (data) in
                guard let fetchedData = data else {
                    DispatchQueue.main.async {
                        self?.img.image = Images.movie}
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
            make.height.equalTo(230)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(30)
            make.width.equalTo(self.img.snp.height).multipliedBy(1.0 / 1.5)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(30)
            make.top.equalTo(img)
            make.height.lessThanOrEqualTo(150)
            make.right.equalTo(-15)
        }
        date.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(30)
            make.top.equalTo(name.snp.bottom).offset(5)
            make.right.equalTo(-15)
        }
        ratingImage.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(date.snp.bottom).offset(30)
            make.left.equalTo(img.snp.right).offset(65)
            make.width.equalTo(ratingImage.snp.height).multipliedBy(1.0 / 1.0)
        }
        rating.snp.makeConstraints { (make) in
            make.top.equalTo(date.snp.bottom).offset(30)
            make.left.equalTo(ratingImage.snp.right).offset(5)
        }
        synopsis.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.left)
            make.top.equalTo(img.snp.bottom).offset(10)
            make.right.equalTo(-30)
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white
        addSubview(img)
        addSubview(name)
        addSubview(date)
        addSubview(rating)
        addSubview(ratingImage)
        addSubview(synopsis)
    }

}
