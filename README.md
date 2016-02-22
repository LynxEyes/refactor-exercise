# QRcode

http://en.wikipedia.org/wiki/QR_Code

## Purpose

This is a simple library that wraps a more complicated QR Code library and outputs to the terminal.

The main file we will be working with is `lib/qrcode.rb`.  It contains a very large `to_s` method that needs refactoring.  Currently there are two tests that pass.

The goal of this exercise is to keep the tests green while refactoring this method to make the code better.


## Installation

Add this line to your application's Gemfile:

    gem 'qrcode'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qrcode

## Usage

    qrcode http://example.com


## QR Code Terminology

Size:
  The size of the grid in squares. 1 through 40.
  Version 1 = 21x21 modules, version 2 = 25x25... version 40 = 177x177.
  http://www.qrcode.com/en/about/version.html

Error Correction:
  L = Low (7%)
  M = Medium (15%)
  Q = Quartile (25%)
  H = High (30%)

