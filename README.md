Vincent L. Cannataro

# ECfitbitR

You can use the `ECfitbitR` package to access your FitBit data through
the FitBit API and format your data for easy analysis. This package
relies heavily on the excellent
[`fitbitr`](https://github.com/teramonagi/fitbitr) package to do the
heavy lifting of interacting with the API. Please visit
[`fitbitr`](https://github.com/teramonagi/fitbitr) for more details of
the extensive functionality therein, as `ECfitbitR` is designed with
limited but specific functionality in mind.

## First things first

### Creating a FitBit web app

The first thing you need to do to access your own FitBit data is make a
personal FitBit API web app.

1.  Go to <https://dev.fitbit.com/apps/new> and log into your FitBit
    account.
2.  Register your application. This is your own personal app for your
    own personal data, so you do not need a terms of service to share
    with clients. Hence, we just use the website of the R package
    (<https://github.com/vcannataro/ECfitbitR>) for our terms.

![](man/figures/screenshot_app_options.png)

3.  Retrieve your Client ID (FITBIT\_KEY) and your Client Secret
    (FITBIT\_SECRET). You can find these here:
    <https://dev.fitbit.com/apps>.

![](man/figures/web_app_settings.png)

You are now ready to access your data\! Well, first you need a toolkit
to use. We will use the free, open source, statistical computing
platform [`R`](https://www.r-project.org/).

### Downloading R

1.  Go to <https://cloud.r-project.org/> and select your specific
    download for your specific operating system.
2.  Follow the instructions to download and install `R`.

## Installation

`ECfitbitR` is a mostly self-contained package, but it does have some
dependencies that need to be installed.

1.  Open R
2.  Click File –\> New Document (or whatever the equivalent is in your
    operating system).
3.  Copy and paste the following into the
document.

<!-- end list -->

``` r
install.packages(c("stringr","lubridate","dplyr","tidyr","purrr","rlang","httr","jsonlite","httpuv","RCurl","devtools"))
```

4.  On the line of the code that you just copied, press `CMD+return` (or
    `ctrl+enter` on PC, etc.)

<!-- end list -->

  - If prompted for a mirror (where the download will come from), click
    the top cloud or whatever is closest to your location
  - If prompted with a message about “Do you want to install from
    sources the package which needs compilation? (Yes/no/cancel)” type
    `Yes` and hit enter.

<!-- end list -->

5.  On a new line in your document, copy the following and then repeat
    step
4

<!-- end list -->

``` r
devtools::install_github("teramonagi/fitbitr"); devtools::install_github("vcannataro/ECfitbitR")
```

You are now ready to download your data\!

Every time a chunk of code is presented below in a gray box, you can
either copy it directly into the R terminal and press `return` or
`Enter`, or you can develop your own `R script` using a New Document
(step 2 above) and press `CMD+return` or `ctrl+enter` to send it to the
terminal. If you copy multiple lines into the `R script` you can send
the code to run in the terminal line-by-line, or you can highlight a
chunk of code and then hit `CMD+return`. The advantage of having the`R
script` is that you can save the script and return to it later—allowing
you to see the exact steps you took to get to your end product (very
important in the reproducibility of science and analyses)\!

Every time you see the `#` sign in the code it is a “comment” and R
automatically does not run comments.

As a general note, you need to run the following code chunks in order
because much of the subsequent code depends on the code prior to it.

## Downloading your FitBit data

### Initializing the API

The first thing we will do is tell FitBit who you are. For this, we need
the `FITBIT_KEY` and `FITBIT_SECRET` generated in the First things first
step.

``` r
# load the key and secret into your R environment. 
FITBIT_KEY <- "your fitbit key pasted here in the quotes"
FITBIT_SECRET <- "your fitbit secret pasted here in the quotes"
```

Next, we will authorize ourselves to obtain our own data. After running
the next block of code your internet browser will prompt you to
authorize your app. Highlight relevant fields and click `Allow`. It will
look like this:

<div style="width:300px; height:300px">

![auth\_img](man/figures/authorize_screenshot.png)

</div>

``` r
token <- fitbitr::oauth_token()
```

### Downloading your data from fitbit

Run the following code to download your data from fitbit:

``` r
my_data <- ECfitbitR::get_my_data(token=token)
```

    ## Getting my data...

    ## Collecting activity data...

    ## Collecting activity data...

    ## Finished date: 2019-09-17... 30 dates left.

    ## Finished date: 2019-09-18... 29 dates left.

    ## Finished date: 2019-09-19... 28 dates left.

    ## Finished date: 2019-09-20... 27 dates left.

    ## Finished date: 2019-09-21... 26 dates left.

    ## Finished date: 2019-09-22... 25 dates left.

    ## Finished date: 2019-09-23... 24 dates left.

    ## Finished date: 2019-09-24... 23 dates left.

    ## Finished date: 2019-09-25... 22 dates left.

    ## Finished date: 2019-09-26... 21 dates left.

    ## Finished date: 2019-09-27... 20 dates left.

    ## Finished date: 2019-09-28... 19 dates left.

    ## Finished date: 2019-09-29... 18 dates left.

    ## Finished date: 2019-09-30... 17 dates left.

    ## Finished date: 2019-10-01... 16 dates left.

    ## Finished date: 2019-10-02... 15 dates left.

    ## Finished date: 2019-10-03... 14 dates left.

    ## Finished date: 2019-10-04... 13 dates left.

    ## Finished date: 2019-10-05... 12 dates left.

    ## Finished date: 2019-10-06... 11 dates left.

    ## Finished date: 2019-10-07... 10 dates left.

    ## Finished date: 2019-10-08... 9 dates left.

    ## Finished date: 2019-10-09... 8 dates left.

    ## Finished date: 2019-10-10... 7 dates left.

    ## Finished date: 2019-10-11... 6 dates left.

    ## Finished date: 2019-10-12... 5 dates left.

    ## Finished date: 2019-10-13... 4 dates left.

    ## Finished date: 2019-10-14... 3 dates left.

    ## Finished date: 2019-10-15... 2 dates left.

    ## Finished date: 2019-10-16... 1 dates left.

    ## Finished date: 2019-10-17... 0 dates left.

    ## Collecting heart rate data...

    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.
    ## Finished date: 2019-10-17... 0 dates left.

    ## Collecting sleep data...
